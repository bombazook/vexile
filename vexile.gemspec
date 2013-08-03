# -*- encoding: utf-8 -*-
require 'base64'
require File.expand_path('../lib/vexile/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Kostrov"]
  gem.email         = Base64.decode64("Ym9tYmF6b29rQGdtYWlsLmNvbQ==\n")
  gem.description   = "Auto generating ActiveModel validations for hashes"
  gem.summary       = "ActiveModel validations for hashes"
  gem.homepage      = "http://malstream.info"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vexile"
  gem.require_paths = ["lib"]
  gem.version       = Vexile::VERSION
  if RUBY_VERSION < "1.9.3"
    gem.add_dependency "activesupport", "~> 3"
    gem.add_dependency 'activemodel', '~> 3'
  else
    gem.add_dependency "activesupport", ">= 3"
    gem.add_dependency 'activemodel', '>= 3'
  end
  gem.add_dependency 'bzproxies', '>= 0.1.11'
  gem.add_dependency 'addressable'
  gem.add_development_dependency "rspec"
end
