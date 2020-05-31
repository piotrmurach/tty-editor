# frozen_string_literal: true

RSpec.describe TTY::Editor, "#executables" do
  it "returns default executables" do
    expect(TTY::Editor.executables).to be_an(Array)
  end

  it "includes default editor execs" do
    allow(ENV).to receive(:[]).with("VISUAL").and_return(nil)
    allow(ENV).to receive(:[]).with("EDITOR").and_return(nil)

    expect(TTY::Editor.executables).to eq([
       "nano", "nano-tiny", "notepad", "vim", "vi", "emacs",
       "pico", "sublime", "mate -w"
    ])
  end
end
