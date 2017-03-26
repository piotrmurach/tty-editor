# encoding: utf-8

require 'tty-editor'

path = File.join(File.expand_path(File.dirname(__FILE__)), '../README.md')

TTY::Editor.open(path) do |editor|
  editor.command :vim, :emacs
end
