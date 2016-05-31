# encoding: utf-8

RSpec.describe TTY::Editor, '#command' do
  it 'escapes editor filename on unix' do
    editor = TTY::Editor.new("/usr/bin/hello world.rb")
    allow(TTY::Editor).to receive(:command).and_return('vim')
    allow(TTY::Platform).to receive(:unix?).and_return(true)

    expect(editor.command_path).to eql("vim /usr/bin/hello\\ world.rb")
  end

  it "escapes path separators on windows" do
    editor = TTY::Editor.new('C:\User\hello world.rb')
    allow(TTY::Editor).to receive(:command).and_return('vim')
    allow(TTY::Platform).to receive(:unix?).and_return(false)
    allow(TTY::Platform).to receive(:windows?).and_return(true)

    expect(editor.command_path).to eql("vim C:\\User\\hello world.rb")
  end
end
