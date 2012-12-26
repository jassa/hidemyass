require 'nokogiri'
require 'open-uri'
require 'faraday'
require 'hidemyass/version'
require 'hidemyass/http'
require 'hidemyass/logger'
require 'logger'


module Hidemyass
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
                 
  def self.options
    @options ||= {
     :log => true,
     :local => false
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
    @proxies ||= load_proxy_from_web("http://hidemyass/proxy-list/search-226094")
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
  end
end