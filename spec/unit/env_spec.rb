# frozen_string_literal: true

RSpec.describe TTY::Editor, "#env" do
  it "configures ENV variables via initializer" do
    allow(described_class).to receive(:available).and_return(["vim"])
    editor = described_class.new(env: {"FOO" => "bar"})

    expect(editor.env).to eq({"FOO" => "bar"})
  end

  it "configures ENV variables via accessor" do
    allow(described_class).to receive(:available).and_return(["vim"])
    editor = described_class.new

    editor.env "FOO" => "bar"

    expect(editor.env).to eq({"FOO" => "bar"})
  end

  it "forwards env variables to command" do
    allow(described_class).to receive(:available).and_return(["vim"])
    file = fixtures_path("content.txt")
    editor = described_class.new(env: {"FOO" => "bar"})
    allow(editor).to receive(:system).and_return(true)

    editor.open(file)

    expect(editor).to have_received(:system).with({"FOO" => "bar"}, "vim", file)
  end
end
