# frozen_string_literal: true

RSpec.describe TTY::Editor, "#open" do
  it "fails to open an existing file with text parameter" do
    allow(described_class).to receive(:available).and_return(["vim"])
    file = fixtures_path("content.txt")
    editor = described_class.new

    expect {
      editor.open(file, text: "some text")
    }.to raise_error(TTY::Editor::InvalidArgumentError,
                     "cannot give a path to an existing file and " \
                     "text at the same time.")
  end

  it "fails to open non-file" do
    allow(described_class).to receive(:available).and_return(["vim"])
    editor = described_class.new

    expect {
      editor.open(fixtures_path)
    }.to raise_error(TTY::Editor::InvalidArgumentError,
                     "don't know how to handle `#{fixtures_path}`. " \
                     "Please provide a file path or text")
  end

  it "opens non-existing file by creating it on the fly with empty content" do
    file = "non-existing.txt"
    allow(::File).to receive(:write).with(file, "")
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])
    editor = described_class.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open(file)).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", file)
  end

  it "opens non-existing file by creating it with new text" do
    file = "non-existing.txt"
    text = "some text"
    allow(::File).to receive(:write).with(file, text)
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])
    editor = described_class.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open(file, text: text)).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", file)
  end

  it "opens an existing file" do
    file = fixtures_path("content.txt")
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])
    editor = described_class.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open(file)).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", file)
  end

  it "opens text in a temp file" do
    tempfile = spy
    allow(tempfile).to receive(:path).and_return("tmp-editor-path")
    allow(Tempfile).to receive(:new).and_return(tempfile)
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])
    editor = described_class.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open(text: "some text")).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", "tmp-editor-path")
    expect(tempfile).to have_received(:<<).with("some text")
    expect(tempfile).to have_received(:unlink)
  end

  it "opens editor without filename or text" do
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])
    editor = described_class.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open).to eq(true)
    expect(editor).to have_received(:system).with({}, "vim", "")
  end

  it "forwards class-level open arguments to initializer" do
    editor = spy(:editor)
    allow(described_class).to receive(:new).with(command: :vim).and_return(editor)

    described_class.open("hello.rb", command: :vim)

    expect(described_class).to have_received(:new).with(command: :vim)
    expect(editor).to have_received(:open).with("hello.rb", {text: nil})
  end

  it "fails to open editor with unknown command" do
    allow(described_class).to receive(:available).with(:unknown).and_return(["unknown"])
    expect {
      described_class.open(fixtures_path("content.txt"), command: :unknown)
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end
end
