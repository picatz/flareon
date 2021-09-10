
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flareon/version"

Gem::Specification.new do |spec|
  spec.name          = "flareon"
  spec.version       = Flareon::VERSION
  spec.authors       = ["Kent 'picat' Gruber"]
  spec.email         = ["kgruber1@emich.edu"]

  spec.summary       = %q{A cloudflare DNS resolver client library.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/picatz/flareon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executable    = "flareon"
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', ">= 0.16.2", "< 0.20.0"
  spec.add_dependency 'parallel', ">= 1.12.1", "< 1.21.0"
  spec.add_dependency 'command_lion', "2.0.1"
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
