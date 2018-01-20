# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libbitcoin/version'

Gem::Specification.new do |spec|
  spec.name          = "libbitcoin"
  spec.version       = Libbitcoin::VERSION
  spec.authors       = ["cryptogopher"]
  spec.email         = [""]

  spec.summary       = %q{Ruby wrapper to C++ library libbitcoin}
  spec.description   = %q{https://libbitcoin.org/}
  spec.homepage      = "https://github.com/cryptogopher/libbitcoin-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
