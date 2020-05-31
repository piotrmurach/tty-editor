# frozen_string_literal: true

require_relative "../lib/tty-editor"

text = <<-EOS
Human madness is oftentimes a cunning and most feline thing.

When you think it fled, it may have but become
transfigured into some still subtler form."
EOS

TTY::Editor.open(content: text)
