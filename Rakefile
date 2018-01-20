require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

task :wrap do
  sh "swig -I/usr/include -I#{RbConfig::CONFIG['rubyhdrdir']} -I#{RbConfig::CONFIG['rubyarchhdrdir']} -D'static_assert(...)=' -v -c++ -ruby ext/bitcoin/bitcoin.i"
end

Rake::ExtensionTask.new "bitcoin" do |ext|
  ext.lib_dir = "lib/bitcoin"
end

Gem::Specification.new "bitcoin", "1.0" do |s|
  s.extensions = %w[ext/bitcoin/extconf.rb]
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
