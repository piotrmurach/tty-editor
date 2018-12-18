# frozen_string_literal: true

require_relative '../lib/tty-editor'

path = File.join(File.expand_path(File.dirname(__FILE__)), '../README.md')

TTY::Editor.open(path, env: {"FOO" => "bar"})
