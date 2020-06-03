# frozen_string_literal: true

RSpec.describe TTY::Editor, "#command" do
  it "specifies desired editor with keyword argument" do
    allow(described_class).to receive(:available).with(:vim).and_return(["vim"])

    editor = described_class.new(command: :vim)

    expect(editor.command).to eq("vim")
  end

  it "specifies desired editor via EDITOR env variable" do
    allow(ENV).to receive(:[]).with("VISUAL").and_return(nil)
    allow(ENV).to receive(:[]).with("EDITOR").and_return("ed -f")
    allow(described_class).to receive(:exist?).with("ed").and_return(true)

    editor = described_class.new

    expect(editor.command).to eq("ed -f")
  end

  it "doesn't find any available editor" do
    allow(described_class).to receive(:available).and_return([])

    expect {
      described_class.new
    }.to raise_error(TTY::Editor::EditorNotFoundError,
                     "could not find a text editor to use. Please specify " \
                     "$VISUAL or $EDITOR or install one of the following " \
                     "editors: nano, notepad, vim, vi, emacs, subl, mate, " \
                     "atom, pico, qe, mg, jed.")
  end

  it "finds only one editor" do
    allow(described_class).to receive(:available).and_return(["vim"])

    editor = described_class.new

    expect(editor.command).to eq("vim")
  end

  it "finds more than one editor" do
    allow(described_class).to receive(:available).and_return(["vim", "emacs"])
    prompt = spy(:prompt, enum_select: "vim", up: "", clear_line: "")
    allow(TTY::Prompt).to receive(:new).and_return(prompt)

    editor = described_class.new

    expect(editor.command).to eq("vim")
  end

  it "caches editor name" do
    allow(described_class).to receive(:available).and_return(["vim"])
    editor = described_class.new

    editor.command
    editor.command

    expect(described_class).to have_received(:available).once
  end
end
