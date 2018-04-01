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

Flareon.resolve?("google.com")
# => true
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
