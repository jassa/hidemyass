require 'open-uri'
require 'faraday'
require 'net/http'
require 'nokogiri'
require 'hidemyass/version'
require 'hidemyass/ip'
require 'hidemyass/http'
require 'hidemyass/logger'
require 'hidemyass/railtie' if defined?(Rails)

module HideMyAss
  extend Logger

  HTTP_ERRORS = [
    Timeout::Error,
    Errno::EINVAL,
    Errno::ECONNRESET,
    EOFError,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError
  ]

  SITE = "http://hidemyass.com".freeze
  # TODO: Find a way to get ideal results in the custom search
  ENDPOINT = "http://hidemyass.com/proxy-list/search-768392".freeze
              
  def self.options
    @options ||= {
      log: true,
      local: false,
      clear_cache: false
    }
  end

  def self.set_option(name, value)
    options = self.options
    options[name] = value unless options[name].nil?
  end


  def self.load_proxy_from(source, address)
    case source
    when :web
      @proxies = load_proxy_from_web(address)
    when :file
      @proxies = load_proxy_from_file(address)
    end
  end

  def self.random_proxy
    self.proxies.sample
  end

  def self.proxies
    @proxies ||= load_proxy_from_web(ENDPOINT)
  end

  def self.load_proxy_from_file(path)
    data = File.read(path)
    p = data.split("\n").map do |d|
      u = d.split(":")
      {host: u[0], port: u[1]}
    end
    return p
  end

  def self.load_proxy_from_web(address)
    html = Nokogiri::HTML(open(URI.parse(address)))

    return html.xpath('//table[@id="listtable"]/tr').collect do |node|
      ip = HideMyAss::IP.new(node.at_xpath('td[2]/span'))
      next unless ip.valid?
      { 
        host: ip.address,
        port: node.at_xpath('td[3]').content.strip
      }
    end
  end
    
  def self.clear_cache
    @proxies = nil
  end
end