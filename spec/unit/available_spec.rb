# encoding: utf-8

RSpec.describe TTY::Editor, '#available' do
  before do
    allow(ENV).to receive(:[]).with('VISUAL').and_return(nil)
    allow(ENV).to receive(:[]).with('EDITOR').and_return(nil)
  end

  it 'finds a single editor' do
    editor = TTY::Editor
    allow(editor).to receive(:exists?).and_return(false)
    allow(editor).to receive(:exists?).with('vim').and_return(true)

    expect(editor.available).to eql(['vim'])
  end

  it "finds all available editors" do
    editor = TTY::Editor
    allow(editor).to receive(:exists?).and_return(false)
    allow(editor).to receive(:exists?).with('vim').and_return(true)
    allow(editor).to receive(:exists?).with('emacs').and_return(true)

    expect(editor.available).to eql(['vim', 'emacs'])
  end

  it "doesn't find command" do
    editor = TTY::Editor
    allow(editor).to receive(:exists?).and_return(false)

    expect(editor.available).to eq([])
  end

  it "uses custom editor" do
    editor = TTY::Editor
    name = 'sublime'
    allow(editor).to receive(:exists?).with(name).and_return(true)
    expect(editor.available(name)).to eql([name])
  end
end
