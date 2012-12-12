# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twoch/version'

Gem::Specification.new do |gem|
  gem.name          = "twoch"
  gem.version       = Twoch::VERSION
  gem.authors       = ["Kazuhiro Yamada"]
  gem.email         = ["kyamada@sonix.asia"]
  gem.description   = %q{2channel client}
  gem.summary       = %q{2channel client}
  gem.homepage      = "https://github.com/k-yamada/twoch"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'thor'
  gem.add_dependency 'mechanize'
  gem.add_development_dependency 'rspec'
end
