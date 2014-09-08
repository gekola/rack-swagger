# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/swagger/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-swagger"
  spec.version       = Rack::Swagger::VERSION
  spec.authors       = ["Colin Rymer", "Tyler Boyd"]
  spec.email         = ["colin.rymer@gmail.com", "tboyd47@gmail.com"]
  spec.summary       = %q{Serve up Swagger UI and docs.}
  spec.description   = %q{Serve up Swagger UI and docs.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack", "~> 1.4"
  spec.add_development_dependency "httpclient", "~> 2"
end
