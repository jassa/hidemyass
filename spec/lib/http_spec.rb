require "spec_helper"

describe HideMyAss::HTTP do

  use_vcr_cassette 'http', record: :new_episodes

  before :all do
    HideMyAss.set_option(:log, false)
  end

  it "load proxies from standard endpoint" do
    conn = HideMyAss::HTTP.new_connection
    conn.should_not be_nil
    conn.class.should be(Faraday::Connection)
    conn.proxy.should_not be_nil
  end

  it "load proxies from custom web address" do
    HideMyAss.load_proxy_from(:web, "http://hidemyass.com/proxy-list/search-25432")
    conn = HideMyAss::HTTP.new_connection
    conn.should_not be_nil
    conn.class.should be(Faraday::Connection)
    conn.proxy.should_not be_nil
  end

  it "load proxies from purchased file" do
    HideMyAss.load_proxy_from(:file, File.dirname(__FILE__) + "/../fixtures/proxies_list.txt")
    conn = HideMyAss::HTTP.new_connection
    conn.should_not be_nil
    conn.class.should be(Faraday::Connection)
    conn.proxy.should_not be_nil
  end

end