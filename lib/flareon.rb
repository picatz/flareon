require "httparty"
require "flareon/version"

module Flareon
  URL    = "https://cloudflare-dns.com/dns-query".freeze
  CT     = "application/dns-json".freeze
  HEADER = {'Content-Type': 'application/json'}
  
  def self.resolve(name, type: "A", json: false)
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

  def self.resolve?(name, type: "A", json: false)
    Flareon.resolve(name, type: type, json: json)
    return true
  rescue
    return false
  end
end
