require "bundler"
Bundler.setup

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("active_layer.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["active_layer.gemspec"] do
  system "gem build active_layer.gemspec"
  system "gem install active_layer-#{NewGem::VERSION}.gem"
end