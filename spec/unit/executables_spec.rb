# frozen_string_literal: true

RSpec.describe TTY::Editor do
  it "includes default editor execs" do
    expect(TTY::Editor::EXECUTABLES).to eq([
      "nano -w", "notepad", "vim", "vi", "emacs",
      "code", "subl -n -w", "mate -w", "atom",
      "pico", "qe", "mg", "jed"
    ])
  end
end
