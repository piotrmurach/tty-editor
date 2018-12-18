# frozen_string_literal: true

RSpec.describe TTY::Editor, '#executables' do
  it "returns default executables" do
    expect(TTY::Editor.executables).to be_an(Array)
  end

  it "includes default editor execs" do
    allow(ENV).to receive(:[]).with('VISUAL').and_return(nil)
    allow(ENV).to receive(:[]).with('EDITOR').and_return(nil)

    expect(TTY::Editor.executables).to eq([
       'vim', 'vi', 'emacs', 'nano', 'nano-tiny', 'pico', 'mate -w'
    ])
  end
end
