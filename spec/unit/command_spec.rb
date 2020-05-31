# frozen_string_literal: true

RSpec.describe TTY::Editor, "#command" do
  it "specifies desired editor" do
    editor = TTY::Editor.new(fixtures_path("content.txt"), command: :vim)
    allow(TTY::Editor).to receive(:available).and_return(["vim"])

    expect(editor.command).to eq(:vim)
  end

  it "doesn't find any available editor" do
    editor = TTY::Editor.new(fixtures_path("content.txt"))
    allow(TTY::Editor).to receive(:available).and_return([])

    expect {
      editor.command
    }.to raise_error(TTY::Editor::EditorNotFoundError,
      /Could not find editor to use. Please specify \$VISUAL or \$EDITOR/)
  end

  it "finds only one editor" do
    editor = TTY::Editor.new(fixtures_path("content.txt"))
    allow(TTY::Editor).to receive(:available).and_return(["vim"])

    expect(editor.command).to eq("vim")
  end

  it "finds more than one editor" do
    editor = TTY::Editor.new(fixtures_path("content.txt"))

    prompt = double(:prompt, enum_select: "vim")

    allow(TTY::Editor).to receive(:available).and_return(["vim", "emacs"])
    allow(TTY::Prompt).to receive(:new).and_return(prompt)

    expect(editor.command).to eq("vim")
  end

  it "caches editor name" do
    editor = TTY::Editor.new(fixtures_path("content.txt"))

    allow(TTY::Editor).to receive(:available).and_return(["vim"])

    editor.command
    editor.command

    expect(TTY::Editor).to have_received(:available).once
  end
end
