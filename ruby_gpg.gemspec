# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby_gpg}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Blake"]
  s.date = %q{2010-07-16}
  s.description = %q{Ruby wrapper for the gpg binary}
  s.email = %q{justin@megablaix.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".autotest",
     ".gitignore",
     "CHANGELOG.markdown",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "cucumber.yml",
     "features/decrypt_string.feature",
     "features/decryption.feature",
     "features/encryption.feature",
     "features/step_definitions/ruby_gpg_steps.rb",
     "features/support/env.rb",
     "lib/ruby_gpg.rb",
     "ruby_gpg.gemspec",
     "spec/ruby_gpg_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "test_keys/pubring.gpg",
     "test_keys/secring.gpg",
     "test_keys/trustdb.gpg"
  ]
  s.homepage = %q{http://github.com/blaix/ruby_gpg}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby wrapper for the gpg binary}
  s.test_files = [
    "spec/ruby_gpg_spec.rb",
     "spec/spec_helper.rb"
  ]

  s.add_development_dependency(%q<rake>, ["~> 10.0"])
  s.add_development_dependency(%q<rspec>, ["~> 2.99.0"])
  s.add_development_dependency(%q<yard>, [">= 0"])
  s.add_development_dependency(%q<cucumber>, [">= 0"])
  s.add_development_dependency(%q<mocha>, [">= 1.1.0"])
end

