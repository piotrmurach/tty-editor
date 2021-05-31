# frozen_string_literal: true

RSpec.describe TTY::Editor do
  it "includes default editor execs" do
    expect(TTY::Editor::EXECUTABLES).to eq([
      "atom", "code", "emacs", "gedit", "jed", "kate",
      "mate -w", "mg", "nano -w", "notepad", "pico", "qe",
      "subl -n -w", "vi", "vim"
    ])
  end

  it "keeps editors list in alphabetical order" do
    expect(TTY::Editor::EXECUTABLES.sort).to eq(TTY::Editor::EXECUTABLES)
  end
end
