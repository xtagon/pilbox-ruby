# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pilbox/version"

Gem::Specification.new do |spec|
  spec.name          = "pilbox"
  spec.version       = Pilbox::VERSION
  spec.authors       = ["Justin Workman"]
  spec.email         = ["xtagon@gmail.com"]

  spec.summary       = "An URL-signing utility for Pilbox, the image resizing service."
  #spec.description   = ""
  #spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake", ["~> 12.3", ">= 12.3.3"]
  spec.add_development_dependency "rspec", "~> 3.9"
end
