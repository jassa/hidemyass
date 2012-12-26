module HideMyAss
  module HTTP

    def self.new_connection
      if HideMyAss.options[:local]
        HideMyAss.log "No Proxy"
        return Faraday.new
      else
        proxy = HideMyAss.random_proxy
        HideMyAss.log "Proxy #{proxy[:host]}:#{proxy[:port]}"
        return Faraday.new proxy: "http://#{proxy[:host]}:#{proxy[:port]}"
      end
    end

    def self.start(address, *arg, &block)
      HideMyAss.log 'Connecting to ' + address + ' through:'
      response = nil
  
      if HideMyAss.options[:local]
        begin
          HideMyAss.log 'localhost...'
          response = Net::HTTP.start(address, *arg, &block)
          if response.class.ancestors.include?(Net::HTTPSuccess)
            return response
          end
        rescue *HTTP_ERRORS => error
          HideMyAss.log error
        end
      end
      
      HideMyAss.proxies.each do |proxy|
        begin
          HideMyAss.log proxy[:host] + ':' + proxy[:port]
          response = Net::HTTP::Proxy(proxy[:host], proxy[:port]).start(address, *arg, &block)
          HideMyAss.log response.class.to_s
          if response.class.ancestors.include?(Net::HTTPSuccess)
            return response
          end
        rescue *HTTP_ERRORS => error
          HideMyAss.log error
        end
      end
    end

  end
end
