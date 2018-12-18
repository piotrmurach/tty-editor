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

  spec.files         = Dir['{lib,spec,examples}/**/*.rb']
  spec.files        += Dir['{bin,tasks}/*', 'tty-editor.gemspec']
  spec.files        += Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt', 'Rakefile']
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'tty-prompt',   '~> 0.18'
  spec.add_dependency 'tty-which',    '~> 0.4'

  spec.add_development_dependency 'bundler', '>= 1.5.0', '< 2.0'
  spec.add_development_dependency 'rake',  '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
