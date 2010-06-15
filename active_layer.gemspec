require File.expand_path("../lib/active_layer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "active_layer"
  s.version     = ActiveLayer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Cooper"]
  s.email       = ["adam.cooper@gmail.com"]
  s.homepage    = "http://github.com/adamcooper/active_layer"
  s.summary     = "ActiveLayer provides validations, attribute filtering, and persistence in a layer sitting on top of any model."
  s.description = "Subscribing to single responsibility principility ActiveLayer aims to provide a layer of context over top a model."

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "active_layer"

  # If you have other dependencies, add them here
  s.add_dependency "activesupport", "~> 3.0.0.beta4"
  s.add_dependency "activemodel", "~> 3.0.0.beta4"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  # s.executables = ["newgem"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end