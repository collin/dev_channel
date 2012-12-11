lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require "dev_channel/version"
 
Gem::Specification.new do |s|
  s.name        = "dev_channel"
  s.version     = DevChannel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Collin Miller"]
  s.email       = ["collintmiller@gmail.com"]
  s.homepage    = "http://github.com/collintmiller/dev_channel"
  s.summary     = "Some friendly Ruby dev_channel tools."
  s.description = %|
    Uses rake pipeline, reel, websockets and more to deliver you continuous
    development.
  |
 
  s.required_rubygems_version = ">= 1.3.6"
  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.require_path = 'lib'
end