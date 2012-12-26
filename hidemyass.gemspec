# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hidemyass/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Javier Saldana" "Andrea Mostosi"]
  gem.email         = ["javier@tractical.com", "andrea.mostosi@zenkay.net"]
  gem.description   = "Hide My Ass! fetches and connects to listed proxies at www.hidemyass.com scraping web page or loading using file."
  gem.summary       = "Hide My Ass! lets you connect anonymously, fetch proxies from hidemyass.com (from web page or from file)."
  gem.homepage      = "http://github.com/zenkay/hidemyass"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hidemyass"
  gem.require_paths = ["lib"]
  gem.version       = Hidemyass::VERSION
  
  gem.add_dependency "nokogiri", "~> 1.5.6"
  gem.add_dependency "faraday", "~> 0.8.4"
end
