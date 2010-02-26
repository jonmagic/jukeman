require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = "jnunemaker-validatable"
  gem.summary     = %Q{Validatable is a library for adding validations.}
  gem.description = %Q{Validatable is a library for adding validations.}
  gem.email       = "nunemaker@gmail.com"
  gem.homepage    = "http://github.com/jnunemaker/validatable"
  gem.authors     = ['Jay Fields', 'John Nunemaker']
  gem.files       = FileList['lib/**/*.rb', '[A-Z]*', 'test/**/*'].to_a
end

Jeweler::GemcutterTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.ruby_opts << '-rubygems'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :test    => :check_dependencies
task :default => :test
