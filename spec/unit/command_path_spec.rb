# frozen_string_literal: true

RSpec.describe TTY::Editor, "#command" do
  it "escapes editor filename on Unix" do
    allow(described_class).to receive(:available).and_return(["vim"])
    filename = "/usr/bin/hello world.rb"
    allow(::FileTest).to receive(:file?).with(filename).and_return(true)
    allow(::File).to receive(:exist?).with(filename).and_return(true)

    editor = described_class.new
    allow(editor).to receive(:system).and_return(true)
    editor.open(filename)

    expect(editor.command_path).to eql("vim /usr/bin/hello\\ world.rb")
  end

  it "escapes path separators on Windows" do
    allow(described_class).to receive(:available).and_return(["vim"])
    filename = 'C:\User\hello world.rb'
    allow(::FileTest).to receive(:file?).with(filename).and_return(true)
    allow(::File).to receive(:exist?).with(filename).and_return(true)

    editor = described_class.new
    allow(editor).to receive(:system).and_return(true)
    editor.open(filename)

    expect(editor.command_path).to eql('vim C:\\\\User\\\\hello\\ world.rb')
  end
end
