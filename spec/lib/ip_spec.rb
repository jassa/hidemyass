require "spec_helper"

describe HideMyAss::IP do

  it "decodes encoded address" do

    # Tipically we would use webmock here to fake the http request,
    # but hidemyass.com seems to be changing their encoding strategy often.
    # By having real data we ensure this gem is working.

    VCR.turn_off!

    html = Nokogiri::HTML(open(URI.parse(HideMyAss::ENDPOINT)))
    HideMyAss::IP.new(html.at_xpath('//table[@id="listtable"]/tr/td[2]/span'))
      .should be_valid

    VCR.turn_on!

  end

end