# encoding: utf-8

RSpec.describe TTY::Editor, '#tempfile_path' do
  it 'creates temporary file path for content' do
    tempfile = StringIO.new
    def tempfile.path
      'random_path'
    end

    allow(FileTest).to receive(:file?).and_return(false)
    allow(Tempfile).to receive(:new).and_return(tempfile)

    editor = TTY::Editor.new("Multiline\ncontent", command: :vim)

    expect(editor.command_path).to eql("vim random_path")
  end
end
