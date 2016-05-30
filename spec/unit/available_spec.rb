# encoding: utf-8

RSpec.describe TTY::Editor, '#available' do
  subject(:editor) { described_class }

  before do
    allow(ENV).to receive(:[]).with('VISUAL').and_return(nil)
    allow(ENV).to receive(:[]).with('EDITOR').and_return(nil)
  end

  it 'finds an editor' do
    allow(editor).to receive(:exists?).with('vi').and_return(true)
    allow(editor).to receive(:exists?).with('emacs').and_return(false)
    expect(editor.available).to eql('vi')
  end

  it "doesn't find command" do
    allow(editor).to receive(:exists?).and_return(false)
    expect(editor.available).to eq(nil)
  end

  it "uses custom editor" do
    name = 'sublime'
    allow(editor).to receive(:exists?).with(name).and_return(true)
    expect(editor.available(name)).to eql(name)
  end
end
