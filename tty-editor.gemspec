# frozen_string_literal: true

require_relative "lib/tty/editor/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-editor"
  spec.version       = TTY::Editor::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{Open a file or text in a preferred terminal text editor.}
  spec.description   = %q{Open a file or text in a preferred terminal text editor.}
  spec.homepage      = "https://ttytoolkit.org"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["bug_tracker_uri"] = "https://github.com/piotrmurach/tty-editor/issues"
  spec.metadata["changelog_uri"] = "https://github.com/piotrmurach/tty-editor/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/tty-editor"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/piotrmurach/tty-editor"

  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.add_dependency "tty-prompt", "~> 0.22"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
