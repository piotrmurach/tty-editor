# encoding: utf-8

RSpec.describe TTY::Editor, '#command' do
  it 'specifies desired editor' do
    editor = TTY::Editor

    allow(editor).to receive(:available).with('vim').and_return(['vim'])
    allow(TTY::Which).to receive(:which).with('vim').and_return('/usr/bin/vim')

    editor.command('vim')

    expect(editor.command).to eq('/usr/bin/vim')
  end

  # it "doesn't find available editor" do
  #   editor = TTY::Editor
  #
  #   allow(editor).to receive(:available).and_return([])
  #
  #   expect {
  #     editor.command
  #   }.to raise_error(TTY::Editor::EditorNotFoundError)
  # end

  it 'finds only one editor' do
    editor = TTY::Editor

    allow(editor).to receive(:available).and_return(['vim'])
    allow(TTY::Which).to receive(:which).with('vim').and_return('/usr/bin/vim')

    editor.command

    expect(editor.command).to eq('/usr/bin/vim')
  end

  it "finds more than one editor" do
    editor = TTY::Editor

    prompt = double(:prompt, enum_select: 'vim')

    allow(editor).to receive(:available).and_return(['vim', 'emacs'])
    allow(TTY::Which).to receive(:which).with('vim').and_return('/usr/bin/vim')
    allow(TTY::Prompt).to receive(:new).and_return(prompt)

    editor.command

    expect(editor.command).to eq('/usr/bin/vim')
  end
end
