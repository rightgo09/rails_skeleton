require 'rake/clean'
CLEAN.include('tmp/4.1.0/*')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
rescue LoadError
end
