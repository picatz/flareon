require "httparty"
require "flareon/version"

module Flareon
  URL    = "https://cloudflare-dns.com/dns-query".freeze
  CT     = "application/dns-json".freeze
  HEADER = {'Content-Type': 'application/json'}

  def self.query(name, type: "A", json: false)
    buffer = StringIO.new
    query  = { name: name, type: type, ct: CT }
    response = HTTParty.get(URL, stream_body: true, query: query, headers: HEADER) do |fragment|
      buffer << fragment
    end
    if response.success?
      buffer = buffer.string
      if json
        return buffer
      else
        return JSON.parse(buffer)
      end
    else
      raise "Got HTTP response code #{response.code}"
    end
  end

  class << self
    alias nslookup query
    alias dig query 
  end

  def self.resolve?(name, type: "A", json: false)
    Flareon.query(name, type: type, json: json)
    return true
  rescue
    return false
  end

  def self.resolve(name, type: "A")
    if type == :ipv4
      type = "A"
    elsif type == :ipv6 
      type = "AAAA" 
    end
    binding.pry
    unless type == "A" || type == "AAAA"
      raise "Unsupported resolve type!" 
    end
    result = Flareon.query(name, type: type)
    if result["Status"] == 0
      return result["Answer"][0]["data"]
    else
      raise result
    end 
  end
end
