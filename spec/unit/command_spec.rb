# encoding: utf-8

RSpec.describe TTY::Editor, '#command' do
  it 'searches available commands' do
    editor = TTY::Editor
    allow(editor).to receive(:available)

    editor.command('vim')

    expect(editor).to have_received(:available).with('vim')
  end
end
