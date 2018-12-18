# frozen_string_literal: true

RSpec.describe TTY::Editor, '#tempfile_path' do
  it 'creates temporary file path for content' do
    tempfile = StringIO.new
    def tempfile.path
      'random-path'
    end

    allow(Tempfile).to receive(:new).and_return(tempfile)
    editor = TTY::Editor.new(content: "Multiline\ncontent", command: :vim)
    allow(editor).to receive(:system).and_return(true)

    editor.open

    expect(editor.command_path).to eql("vim random-path")
  end
end
