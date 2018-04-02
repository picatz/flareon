# Flareon
> A cloudflare DNS over HTTPS resolver client library.

<p align="center">
  <img alt="Pokemon, gott'a catch 'em all!" src="flareon.png"/>
<p>

Cloudflare’s DNS over HTTPS [endpoint](https://cloudflare-dns.com/dns-query) supports [JSON format](https://developers.cloudflare.com/1.1.1.1/dns-over-https/json-format/) for querying [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) data -- and this gem helps to use it!

## Installation

    $ gem install flareon

## Usage

Perform a basic DNS query over HTTPs:
```ruby
Flareon.query("google.com")
# => {
#     "Status"=>0,
#     "TC"=>false,
#     "RD"=>true,
#     "RA"=>true,
#     "AD"=>false,
#     "CD"=>false,
#     "Question"=>[{"name"=>"google.com.", "type"=>1}],
#     "Answer"=>[{"name"=>"google.com.", "type"=>1, "TTL"=>83, "data"=>"172.217.1.46"}]
#    }
```

Get the raw JSON response:
```ruby
json = Flareon.query("google.com", json: true)
```

Specify [DNS query type](https://en.wikipedia.org/wiki/List_of_DNS_record_types):
```ruby
Flareon.query("google.com", type: "A")
Flareon.query("google.com", type: "AAAA")
Flareon.query("google.com", type: "MX")
```

The `nslookup` method is an alias for the `query` method:
```ruby
Flareon.nslookup("google.com")
```

The `dig` method is an alias for the `query` method:
```ruby
Flareon.dig("google.com")
```

Check if a given name is resolvable:
```ruby
Flareon.resolve?("google.com")
# => true
```

Resolve a given domain to an IP address:
```ruby
Flareon.resolve("google.com")
# => "172.217.1.46"
```

Resolve a given domain to an IPv4 address:
```ruby
Flareon.resolve("google.com")
Flareon.resolve("google.com", type: "A")
Flareon.resolve("google.com", type: 1)
```

Resolve a given domain to an IPv6 address:
```ruby
Flareon.resolve("google.com", type: "AAAA")
Flareon.resolve("google.com", type: 28)
```

Resolve a give domain to all IPv4 and IPv6 addresses:
```ruby
Flareon.resolve_all("google.com")

# or

Flareon.resolve_all("google.com") do |ip_address|
  # do something with the ip_address
  puts ip_address
end
```

## Inspiration

Saw [hrbrmstr](https://github.com/hrbrmstr) working on [dnsflare](https://github.com/hrbrmstr/dnsflare) and wanted something similiar in Ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
