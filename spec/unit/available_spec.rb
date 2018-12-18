# frozen_string_literal: true

RSpec.describe TTY::Editor, '#available' do
  before do
    allow(ENV).to receive(:[]).with('VISUAL').and_return(nil)
    allow(ENV).to receive(:[]).with('EDITOR').and_return(nil)
    allow(TTY::Editor).to receive(:windows?).and_return(false)
  end

  it "detects editor from env" do
    allow(ENV).to receive(:[]).with('VISUAL').and_return('vi')

    expect(TTY::Editor.available).to eq(['vi'])
  end

  it "offers notepad editor on windows platform" do
    allow(TTY::Editor).to receive(:windows?).and_return(true)

    expect(TTY::Editor.available).to eq(['notepad'])
  end

  it 'finds a single editor on unix' do
    editor = TTY::Editor
    allow(editor).to receive(:exist?).and_return(false)
    allow(editor).to receive(:exist?).with('vim').and_return(true)

    expect(editor.available).to eql(['vim'])
  end

  it "finds all available editors" do
    editor = TTY::Editor
    allow(editor).to receive(:exist?).and_return(false)
    allow(editor).to receive(:exist?).with('vim').and_return(true)
    allow(editor).to receive(:exist?).with('emacs').and_return(true)

    expect(editor.available).to eql(['vim', 'emacs'])
  end

  it "doesn't find any editor on unix" do
    editor = TTY::Editor
    allow(editor).to receive(:exist?).and_return(false)

    expect(editor.available).to eq([])
  end

  it "uses custom editor" do
    editor = TTY::Editor
    name = 'sublime'

    expect(editor.available(name)).to eql([name])
  end
end
