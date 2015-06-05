Gem::Specification.new do |spec|
  spec.name          = "lita-down-for-everyone"
  spec.version       = "0.0.4"
  spec.authors       = ["Jordan Killpack"]
  spec.email         = ["jordan@bignerdranch.com"]
  spec.homepage      = "http://www.github.com/killpack/lita-down-for-everyone"
  spec.description   = %q{Lita, is github.com down?}
  spec.summary       = %q{Lita, is github.com down?}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0.beta2"
end
