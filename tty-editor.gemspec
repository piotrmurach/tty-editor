# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/editor/version'

Gem::Specification.new do |spec|
  spec.name          = "tty-editor"
  spec.version       = TTY::Editor::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]

  spec.summary       = %q{Opens a file or text in the user's preferred editor.}
  spec.description   = %q{Opens a file or text in the user's preferred editor.}
  spec.homepage      = "https://piotrmurach.github.io/tty"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'tty-prompt',   '~> 0.16.0'
  spec.add_dependency 'tty-which',    '~> 0.3.0'

  spec.add_development_dependency 'bundler', '>= 1.5.0', '< 2.0'
  spec.add_development_dependency 'rake',  '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
