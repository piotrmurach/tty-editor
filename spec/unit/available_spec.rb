# frozen_string_literal: true

RSpec.describe TTY::Editor, ".available" do
  before do
    allow(ENV).to receive(:[]).with("VISUAL").and_return(nil)
    allow(ENV).to receive(:[]).with("EDITOR").and_return(nil)
  end

  it "detects editor from the VISUAL env variable" do
    allow(ENV).to receive(:[]).with("VISUAL").and_return("env-editor")
    allow(described_class).to receive(:exist?).and_return(false)
    allow(described_class).to receive(:exist?).with("env-editor").and_return(true)

    expect(described_class.available).to eq(["env-editor"])
  end

  it "detects editor from the EDITOR env variable" do
    allow(ENV).to receive(:[]).with("EDITOR").and_return("env-editor")
    allow(described_class).to receive(:exist?).and_return(false)
    allow(described_class).to receive(:exist?).with("env-editor").and_return(true)

    expect(described_class.available).to eq(["env-editor"])
  end

  it "offers notepad editor on windows platform" do
    allow(described_class).to receive(:exist?).and_return(false)
    allow(described_class).to receive(:exist?).with("notepad").and_return(true)

    expect(described_class.available).to eq(["notepad"])
  end

  it "finds a single editor on unix" do
    allow(described_class).to receive(:exist?).and_return(false)
    allow(described_class).to receive(:exist?).with("vim").and_return(true)

    expect(described_class.available).to eql(["vim"])
  end

  it "finds all available editors" do
    allow(described_class).to receive(:exist?).and_return(false)
    allow(described_class).to receive(:exist?).with("vim").and_return(true)
    allow(described_class).to receive(:exist?).with("emacs").and_return(true)

    expect(described_class.available).to eql(["vim", "emacs"])
  end

  it "doesn't find any text editor" do
    allow(described_class).to receive(:exist?).and_return(false)

    expect(described_class.available).to eq([])
  end

  it "uses custom editor" do
    allow(described_class).to receive(:exist?).and_return(true)

    expect(described_class.available("custom")).to eql(["custom"])
  end
end
