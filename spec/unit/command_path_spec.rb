# frozen_string_literal: true

RSpec.describe TTY::Editor, '#command' do
  it 'escapes editor filename on Unix' do
    filename = "/usr/bin/hello world.rb"
    allow(::FileTest).to receive(:file?).with(filename).and_return(true)
    allow(::File).to receive(:exist?).with(filename).and_return(true)
    allow(TTY::Editor).to receive(:windows?).and_return(false)

    editor = TTY::Editor.new(filename, command: :vim)

    expect(editor.command_path).to eql("vim /usr/bin/hello\\ world.rb")
  end

  it "escapes path separators on Windows" do
    filename = 'C:\User\hello world.rb'
    allow(::FileTest).to receive(:file?).with(filename).and_return(true)
    allow(::File).to receive(:exist?).with(filename).and_return(true)
    allow(TTY::Editor).to receive(:windows?).and_return(true)

    editor = TTY::Editor.new(filename, command: :vim)

    expect(editor.command_path).to eql("vim C:\\\\User\\\\hello\\ world.rb")
  end
end
