# encoding: utf-8

RSpec.describe TTY::Editor, '#run' do
  it 'runs editor command successfully' do
    editor = TTY::Editor.new(fixtures_path('hello.txt'))
    allow(editor).to receive(:command_path).and_return('vim hello.txt')
    allow(editor).to receive(:system).and_return(true)

    editor.run

    expect(editor).to have_received(:system).with('vim', 'hello.txt')
  end

  it 'fails to run editor command' do
    editor = TTY::Editor.new(fixtures_path('hello.txt'))
    allow(editor).to receive(:command_path).and_return('vim hello.rb')
    allow(editor).to receive(:system).and_return(false)

    expect {
      editor.run
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end
end
