# -*- encoding: utf-8 -*-
require File.expand_path('../lib/calendar_builder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marcos G. Zimmermann"]
  gem.email         = ["mgzmaster@gmail.com"]
  gem.description   = %q{Simple calendar helper}
  gem.summary       = %q{Simple calendar helper}
  gem.homepage      = "http://github.com/marcosgz/calendar_builder"
  gem.license       = %q{MIT}

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"


  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "calendar_builder"
  gem.require_paths = ["lib"]
  gem.version       = CalendarBuilder::VERSION
end
