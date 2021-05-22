# frozen_string_literal: true

RSpec.describe TTY::Editor, "#new" do
  it "yields editor to allow configuration" do
    allow(described_class).to receive(:available).and_return(["vim"])

    editor = described_class.new do |ed|
      ed.command :vim, :emacs
      ed.env "FOO" => "bar"
    end

    expect(editor.command).to eq("vim")
    expect(editor.env).to eq({"FOO" => "bar"})
  end
end
