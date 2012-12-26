module Hidemyass
  module HTTP

    def self.new_connection
      if Hidemyass.options[:local]
        self.log "No Proxy"
        return Faraday.new
      else
        proxy = self.random_proxy
        self.log "Proxy #{proxy[:host]}:#{proxy[:port]}"
        return Faraday.new proxy: "http://#{proxy[:host]}:#{proxy[:port]}"
      end
    end

  end
end
