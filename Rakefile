require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby_gpg"
    gem.summary = %Q{Ruby wrapper for the gpg binary}
    gem.description = %Q{Ruby wrapper for the gpg binary}
    gem.email = "justin@megablaix.com"
    gem.homepage = "http://github.com/blaix/ruby_gpg"
    gem.authors = ["Justin Blake"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "cucumber", ">= 0"
    gem.add_development_dependency "mocha", ">= 0.9.8"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

namespace :spec do
  RSpec::Core::RakeTask.new(:doc) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.spec_opts << '--format specdoc'
  end
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |y|
    y.files << '-' << 'CHANGELOG.*' << 'TODO.*'
  end
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
