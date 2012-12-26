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

  def self.load_proxy_from(source, address)
    case source
    when :web
      load_proxy_from_web(address)
    when :file
      load_proxy_from_file(address)
    end
  end

  def self.proxies
    @proxies ||= load_proxy_from_web(ENDPOINT)
  end

  def self.load_proxy_from_file(path)
    data = File.read(@@path)
    proxies = data.split("\n").map do |d|
      u = d.split(":")
      {host: u[0], port: u[1]}
    end
    return proxies
  end

  def self.load_proxy_from_web(address)
    uri = URI.parse(address)
    dom = Nokogiri::HTML(open(uri))
    return dom.xpath('//table[@id="listtable"]/tr').collect do |node|
      { port: node.at_xpath('td[3]').content.strip, host: node.at_xpath('td[2]/span').xpath('text() | *[not(contains(@style,"display:none"))]').map(&:content).compact.join.to_s }
  end
    
  def self.clear_cache
    @proxies = nil
  end
end