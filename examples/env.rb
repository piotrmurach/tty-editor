# frozen_string_literal: true

require_relative "../lib/tty-editor"

file = File.join(__dir__, "../README.md")

TTY::Editor.open(file, env: {"FOO" => "bar"})
