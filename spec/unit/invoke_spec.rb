# encoding: utf-8

RSpec.describe TTY::Editor, '#invoke' do
  it 'executes editor command successfully' do
    editor = TTY::Editor.new('hello.rb')
    allow(editor).to receive(:command_path).and_return('vim hello.rb')
    allow(editor).to receive(:system).and_return(true)
    editor.invoke
    expect(editor).to have_received(:system).with('vim', 'hello.rb')
  end

  it 'fails to execute editor command' do
    editor = TTY::Editor.new('hello.rb')
    allow(editor).to receive(:command_path).and_return('vim hello.rb')
    allow(editor).to receive(:system).and_return(false)
    expect {
      editor.invoke
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end
end
