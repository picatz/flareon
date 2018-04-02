require 'resolv'

RSpec.describe Flareon do
  it "has a version number" do
    expect(Flareon::VERSION).not_to be nil
  end
  
  it "can query google.com" do
    resp = Flareon.query("google.com")
    expect(resp["Status"]).to eq(0)
    expect(resp["TC"]).to be(true).or be(false)
    expect(resp["RD"]).to be(true).or be(false)
    expect(resp["RA"]).to be(true).or be(false)
    expect(resp["AD"]).to be(true).or be(false)
    expect(resp["CD"]).to be(true).or be(false)
    expect(resp["Question"]).to be_a(Array)
    expect(resp["Question"][0]).to be_a(Hash)
    expect(resp["Answer"]).to be_a(Array)
    expect(resp["Answer"][0]).to be_a(Hash)
  end

  it "can resolve google.com" do
    resp = Flareon.resolve?("google.com")
    expect(resp).to eq(true)
  end
  
  it "can resolve google.com to an IPv4 address" do
    case Flareon.resolve("google.com")
    when Resolv::IPv4::Regex
      true
    else
      false
    end
  end
  
  it "can resolve google.com to an IPv6 address" do
    case Flareon.resolve("google.com", type: "AAAA")
    when Resolv::IPv4::Regex
      true
    else
      false
    end
  end
  
  it "can query for google.com and return the raw JSON response" do
    resp = Flareon.query("google.com", json: true)
    hash = JSON.parse(resp)
    expect(hash["Status"]).to eq(0)
  end

  it "has alias 'dig' for query method" do
    resp1 = Flareon.query("google.com", json: true)
    resp2 = Flareon.dig("google.com", json: true)
    expect(resp1).to eq(resp2)
  end

  it "has alias 'nslookup' for query method" do
    resp1 = Flareon.query("google.com", json: true)
    resp2 = Flareon.nslookup("google.com", json: true)
    expect(resp1).to eq(resp2)
  end

end
