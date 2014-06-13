# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'barking_iguana/verify/version'

Gem::Specification.new do |spec|
  spec.name          = "barking_iguana-verify"
  spec.version       = BarkingIguana::Verify::VERSION
  spec.authors       = ["Craig R Webster"]
  spec.email         = ["craig@barkingiguana.com"]
  spec.summary       = %q{Verify that a remote caller is who they say they are without sending password or API keys over the wire.}
  spec.description   = %q{Verify that a remote caller is who they say they are.

Don't send passwords or API keys over the wire. That's risky.

Make sure replay attacks have a very limited window in case someone has
listened in to the HTTP conversation somehow.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
