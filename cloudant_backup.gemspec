# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudant_backup/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudant_backup"
  spec.version       = CloudantBackup::VERSION
  spec.authors       = ["Jannis Hermanns"]
  spec.email         = ["jannis@gmail.com"]
  spec.description   = %q{Makes a backup of a cloudant db}
  spec.summary       = %q{Why yes, I made a gem that does nothing but two http requests}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rest-client"
  spec.add_dependency "guard-rspec"
  spec.add_dependency "guard-bundler"
  spec.add_dependency "guard"
end
