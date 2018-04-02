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
    return true if Flareon.resolve(name, type: type)
  rescue
    return false
  end

  def self.resolve(name, type: "A")
    unless type == "A" || type == "AAAA"
      raise "Unsupported resolve type!" 
    end
    resp = Flareon.query(name, type: type)
    if resp["Status"] == 0
      return resp["Answer"][0]["data"]
    else
      raise resp 
    end 
  end

  def self.resolve_all(name, type: :both)
    unless type == "A" || type == "AAAA" || type == :both
      raise "Unsupported resolve type!" 
    end
    results = [] unless block_given?
    case type
    when "A", "AAAA"
      resp = Flareon.query(name, type: type)
      if resp["Status"] == 0
        resp["Answer"].each do |answer|
          if block_given?
            yield answer["data"]
          else
            results << answer["data"]
          end
        end
      else
        raise resp 
      end
    when :both
      if block_given?
        Flareon.resolve_all(name, type: "A")    { |ip| yield ip }
        Flareon.resolve_all(name, type: "AAAA") { |ip| yield ip } 
      else
        Flareon.resolve_all(name, type: "A")    { |ip| results << ip }
        Flareon.resolve_all(name, type: "AAAA") { |ip| results << ip }
      end
    end
    return results unless block_given?
  end
end
