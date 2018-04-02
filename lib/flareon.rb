require "httparty"
require "flareon/version"

module Flareon
  # Base URL for cloudflare's DNS over HTTPs endpoint.
  URL    = "https://cloudflare-dns.com/dns-query".freeze
  # Special *ct* value to add to every query.
  CT     = "application/dns-json".freeze
  # Header sent in every query.
  HEADER = {'Content-Type': 'application/json'}

  # Query the DNS over HTTPs endpoint.
  # 
  # == IPv4 DNS query
  #   result = Flareon.query("google.com")
  #   # or
  #   result = Flareon.query("google.com", type: "A")
  #   # or
  #   result = Flareon.query("google.com", type: 1)
  #
  # == IPv6 DNS query
  #   result = Flareon.query("google.com", type: "AAAA") 
  #   # or
  #   result = Flareon.query("google.com", type: 28)
  #
  # == Mail exchange record query
  #   result = Flareon.query("google.com", type: "MX") 
  #   # or
  #   result = Flareon.query("google.com", type: 15)
  # == Raw JSON response ( not parsed )
  #   result = Flareon.query("google.com", json: true)
  #
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

  # Alias the query method with both nslookup and dig.
  # This keeps a similiar API to: github.com/hrbrmstr/dnsflare
  class << self
    alias nslookup query
    alias dig query 
  end

  # Check if a given domain name is resolvable to an IPv4 or IPv6 address.
  def self.resolve?(name, type: "A", json: false)
    Flareon.resolve_all(name) do |ip|
      return true
    end
    false
  rescue
    return false
  end

  # Resolve a given domain name to a IP address. 
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

  # Resolve a given domain name to all addresses (IPv4/IPv6). 
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
