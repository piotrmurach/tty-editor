# frozen_string_literal: true

RSpec.describe TTY::Editor do
  it "creates temporary file path for content" do
    tempfile = spy
    allow(Tempfile).to receive(:new).and_return(tempfile)
    allow(tempfile).to receive(:path).and_return("temp-path")
    allow(described_class).to receive(:available).and_return(["vim"])
    editor = TTY::Editor.new(command: "vim")
    allow(editor).to receive(:system).and_return(true)

    editor.open(content: "Multiline\ncontent")

    expect(editor).to have_received(:system).with({}, "vim", "temp-path")
    expect(tempfile).to have_received(:unlink)
  end
end
