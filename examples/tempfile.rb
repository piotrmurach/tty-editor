# encoding: utf-8

require 'tty-editor'

content = "Human madness is oftentimes a cunning and most feline thing.\n When you think it fled, it may have but become transfigured into some still subtler form."

TTY::Editor.open(content)
