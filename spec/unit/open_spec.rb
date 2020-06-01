# frozen_string_literal: true

require "fileutils"

RSpec.describe TTY::Editor, "#open" do
  it "fails to open an existing file with text parameter" do
    file = fixtures_path("content.txt")

    expect {
      TTY::Editor.new(file, content: "some text")
    }.to raise_error(TTY::Editor::InvalidArgumentError,
                     "cannot give a path to an existing file and " \
                     "text at the same time.")
  end

  it "fails to open non-file" do
    expect {
      TTY::Editor.open(fixtures_path)
    }.to raise_error(TTY::Editor::InvalidArgumentError,
                     "don't know how to handle `#{fixtures_path}`. " \
                     "Please provide a file path or text")
  end

  it "opens non-existing file by creating it on the fly with empty content" do
    file = "non-existing.txt"
    allow(::File).to receive(:write).with(file, "")
    editor = TTY::Editor.new(file, command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", file)
  end

  it "opens non-existing file by creating it with new text" do
    file = "non-existing.txt"
    text = "some text"
    allow(::File).to receive(:write).with(file, text)
    editor = TTY::Editor.new(file, content: text, command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", file)
  end

  it "opens an existing file" do
    file = fixtures_path("content.txt")
    editor = TTY::Editor.new(file, command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", file)
  end

  it "opens content in a temp file" do
    tempfile = spy
    allow(tempfile).to receive(:path).and_return("tmp-editor-path")
    allow(Tempfile).to receive(:new).and_return(tempfile)
    editor = TTY::Editor.new(content: "some text", command: :vim)
    allow(editor).to receive(:system).and_return(true)

    expect(editor.open).to eq(true)

    expect(editor).to have_received(:system).with({}, "vim", "tmp-editor-path")
    expect(tempfile).to have_received(:<<).with("some text")
    expect(tempfile).to have_received(:unlink)
  end

  it "opens editor without filename or content" do
    editor = TTY::Editor.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)
    expect(editor).to have_received(:system).with({}, "vim", "")
  end

  it "forwards class-level open arguments to initializer" do
    invocable = double(:invocable, open: nil)
    allow(TTY::Editor).to receive(:new).
      with("hello.rb", command: :vim).and_return(invocable)

    TTY::Editor.open("hello.rb", command: :vim)

    expect(TTY::Editor).to have_received(:new).with("hello.rb", command: :vim)
  end

  it "fails to open editor with unknown command" do
    expect {
      TTY::Editor.open(fixtures_path("content.txt"), command: :unknown)
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end
end
