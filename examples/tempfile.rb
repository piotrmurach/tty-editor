# frozen_string_literal: true

require_relative '../lib/tty-editor'

content = "Human madness is oftentimes a cunning and most feline thing.\n When you think it fled, it may have but become transfigured into some still subtler form."

TTY::Editor.open(content: content)
