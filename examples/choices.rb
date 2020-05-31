# frozen_string_literal: true

require_relative "../lib/tty-editor"

path = File.join(__dir__, "../README.md")

TTY::Editor.open(path) do |editor|
  editor.command :vim, :emacs
end
