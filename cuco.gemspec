require_relative "lib/cuco/version"

Gem::Specification.new do |s|
  s.name = "cuco"
  s.version = Cuco::VERSION
  s.summary = "A file watcher"
  s.description = "A simple and flexible file watcher"

  s.authors = ["Dittmar Krall"]
  s.email = "dittmar.krall@matiq.de"
  s.homepage = "http://www.matiq.de"
  s.license = "MIT"

  s.files = Dir["bin/**/*"]
  s.files += Dir["lib/**/*"]
  s.files += Dir["scripts/**/*"]
  s.extra_rdoc_files = Dir["README.md", "MIT-LICENSE"]

  s.executables = `git ls-files -- bin/*`
    .split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 3"

  s.add_runtime_dependency "listen"
  s.add_runtime_dependency "micro-optparse"

  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"
end
