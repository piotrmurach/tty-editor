# encoding: utf-8

RSpec.describe TTY::Editor, '#command' do
  it 'escapes editor filename on unix' do
    editor = TTY::Editor.new("/bin/ruby hello.rb")
    allow(TTY::Editor).to receive(:command).and_return('vim')
    allow(TTY::Platform).to receive(:unix?).and_return(true)

    expect(editor.command_path).to eql("vim /bin/ruby\\ hello.rb")
  end

  it "doesn't shell escape on windows" do
    editor = TTY::Editor.new("/bin/ruby hello.rb")
    allow(TTY::Editor).to receive(:command).and_return('vim')
    allow(TTY::Platform).to receive(:unix?).and_return(false)
    allow(TTY::Platform).to receive(:windows?).and_return(true)

    expect(editor.command_path).to eql("vim \\bin\\ruby hello.rb")
  end
end
