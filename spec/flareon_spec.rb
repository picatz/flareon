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
    resp1 = Flareon.query("google.com")
    resp2 = Flareon.dig("google.com")
    expect(resp1["Status"]).to eq(resp2["Status"])
    expect(resp1["TC"]).to eq(resp2["TC"])
    expect(resp1["RD"]).to eq(resp2["RD"])
    expect(resp1["RA"]).to eq(resp2["RA"])
    expect(resp1["AD"]).to eq(resp2["AD"])
    expect(resp1["CD"]).to eq(resp2["CD"])
    expect(resp1["CD"]).to eq(resp2["CD"])
    expect(resp1["CD"]).to eq(resp2["CD"])
    expect(resp1["Question"]).to eq(resp2["Question"])
    expect(resp1["Answer"][0]["name"]).to eq(resp2["Answer"][0]["name"])
  end

  it "has alias 'nslookup' for query method" do
    resp1 = Flareon.query("google.com")
    resp2 = Flareon.dig("google.com")
    expect(resp1["Status"]).to eq(resp2["Status"])
    expect(resp1["TC"]).to eq(resp2["TC"])
    expect(resp1["RD"]).to eq(resp2["RD"])
    expect(resp1["RA"]).to eq(resp2["RA"])
    expect(resp1["AD"]).to eq(resp2["AD"])
    expect(resp1["CD"]).to eq(resp2["CD"])
    expect(resp1["CD"]).to eq(resp2["CD"])
    expect(resp1["CD"]).to eq(resp2["CD"])
    expect(resp1["Question"]).to eq(resp2["Question"])
    expect(resp1["Answer"][0]["name"]).to eq(resp2["Answer"][0]["name"])
  end
  
  it "has a single-threaded batch query method" do
    domains = ["google.com", "github.com", "microsoft.com", "apple.com"]
    results = Flareon.batch_query(domains)
    expect(results.size).to eq(domains.size)
    results.each do |result|
      expect(result["Status"]).to eq(0)
    end
  end

  it "has a multi-threaded batch query method" do
    domains = ["google.com", "github.com", "microsoft.com", "apple.com"]
    results = Flareon.batch_query_multithreaded(domains, threads: 4) do |result|
      expect(result["Status"]).to eq(0)
    end
    expect(results.size).to eq(domains.size)
  end

end
