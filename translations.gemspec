# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'translations/version'

Gem::Specification.new do |gem|
  gem.name          = "translations"
  gem.version       = Translations::VERSION
  gem.authors       = ["Marten Lienen"]
  gem.email         = ["marten.lienen@gmail.com"]
  gem.description   = %q{Manage YAML translations}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/CQQL/translations"

  gem.add_dependency "highline", "~> 1.6.15"
  gem.add_dependency "thor", "~> 0.17.0"

  gem.add_development_dependency "rspec", "~> 2.12.0"
  gem.add_development_dependency "wrong", "~> 0.7.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
