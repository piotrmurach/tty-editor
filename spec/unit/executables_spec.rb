# frozen_string_literal: true

RSpec.describe TTY::Editor, "#executables" do
  it "includes default editor execs" do
    allow(ENV).to receive(:[]).with("VISUAL").and_return(nil)
    allow(ENV).to receive(:[]).with("EDITOR").and_return(nil)

    expect(TTY::Editor.executables).to eq([
      "nano -w", "notepad", "vim", "vi", "emacs",
      "subl -n -w", "mate -w", "atom",
      "pico", "qe", "mg", "jed"
    ])
  end
end
