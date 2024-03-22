require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "cuco"
  s.version = Cuco::VERSION
  s.summary = "A file watcher"
  s.description = "A simple and flexible file watcher"

  s.authors = ["Dittmar Krall"]
  s.email = "dittmar.krall@matiq.de"
  s.homepage = "http://www.matiq.de"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`
    .split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "micro-optparse", "~> 0"
  s.add_runtime_dependency "listen", "~> 0"

  s.add_development_dependency "minitest", "~> 0"
  s.add_development_dependency "rake", "~> 0"
end
