# frozen_string_literal: true

RSpec.describe TTY::Editor, "#exist?" do
  it "successfully checks editr exists on the system" do
    allow(ENV).to receive(:fetch).with("PATHEXT", "").and_return("")
    allow(ENV).to receive(:fetch).with("PATH", "").and_return("/usr/local/bin/")
    allow(::File).to receive(:exist?)
      .with(::File.join("/usr/local/bin", "vim")).and_return(true)

    expect(described_class.exist?("vim")).to eq(true)
  end

  it "successfully checks editor with extensions exists on the system" do
    allow(ENV).to receive(:fetch).with("PATHEXT", "").and_return(".exe")
    allow(ENV).to receive(:fetch).with("PATH", "").and_return("/usr/local/bin/")
    allow(::File).to receive(:exist?)
      .with(::File.join("/usr/local/bin", "vim")).and_return(false)
    allow(::File).to receive(:exist?)
      .with(::File.join("/usr/local/bin", "vim.exe")).and_return(true)

    expect(described_class.exist?("vim.exe")).to eq(true)
  end

  it "fails to check editor exists on the system" do
    allow(ENV).to receive(:fetch).with("PATHEXT", "").and_return("")
    allow(ENV).to receive(:fetch).with("PATH", "").and_return("/usr/local/bin/")
    allow(::File).to receive(:exist?)
      .with(::File.join("/usr/local/bin", "vim")).and_return(false)

    expect(described_class.exist?("vim")).to eq(false)
  end
end
