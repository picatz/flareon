# Flareon
> A cloudflare DNS resolver client library.

## Installation

    $ gem install flareon

## Usage

```ruby
Flareon.resolve("google.com")
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

```ruby
json = Flareon.resolve("google.com", json: true)
```

```ruby
Flareon.resolve?("google.com")
# => true
```

## Inspiration

Saw [hrbrmstr](https://github.com/hrbrmstr) working on [dnsflare](https://github.com/hrbrmstr/dnsflare) and wanted something similiar in Ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
