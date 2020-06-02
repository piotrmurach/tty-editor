# frozen_string_literal: true

RSpec.describe TTY::Editor, "#command" do
  it "specifies desired editor with keyword argument" do
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])
    editor = TTY::Editor.new(fixtures_path("content.txt"), command: :vim)

    expect(editor.command).to eq("vim")
  end

  it "specifies desired editor via EDITOR env variable" do
    allow(ENV).to receive(:[]).with("VISUAL").and_return(nil)
    allow(ENV).to receive(:[]).with("EDITOR").and_return("ed -f")
    allow(described_class).to receive(:exist?).with("ed").and_return(true)

    editor = TTY::Editor.new(fixtures_path("content.txt"))

    expect(editor.command).to eq("ed -f")
  end

  it "doesn't find any available editor" do
    allow(described_class).to receive(:available).and_return([])

    expect {
      described_class.new(fixtures_path("content.txt"))
    }.to raise_error(TTY::Editor::EditorNotFoundError,
      /Could not find editor to use. Please specify \$VISUAL or \$EDITOR/)
  end

  it "finds only one editor" do
    allow(described_class).to receive(:available).and_return(["vim"])

    editor = described_class.new(fixtures_path("content.txt"))

    expect(editor.command).to eq("vim")
  end

  it "finds more than one editor" do
    allow(described_class).to receive(:available).and_return(["vim", "emacs"])
    prompt = double(:prompt, enum_select: "vim")
    allow(TTY::Prompt).to receive(:new).and_return(prompt)

    editor = described_class.new(fixtures_path("content.txt"))

    expect(editor.command).to eq("vim")
  end

  it "caches editor name" do
    allow(described_class).to receive(:available).and_return(["vim"])
    editor = described_class.new(fixtures_path("content.txt"))

    editor.command
    editor.command

    expect(described_class).to have_received(:available).once
  end
end
