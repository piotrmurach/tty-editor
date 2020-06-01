# frozen_string_literal: true

RSpec.describe TTY::Editor do
  around :each do |example|
    Dir.mktmpdir do |dir|
      FileUtils.cd(dir) do
        example.run
      end
    end
  end

  it "opens text in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"

    expect {
      described_class.open(content: "Some text", command: editor_command)
    }.to output("Some text").to_stdout_from_any_process
  end

  it "opens an existing file in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"
    file = fixtures_path("content.txt")

    expect {
      described_class.open(file, command: editor_command)
    }.to output("one\ntwo\nthree\n").to_stdout_from_any_process
  end

  it "opens a new file in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"

    described_class.open("newfile.txt", command: editor_command)

    expect(::File.exist?("newfile.txt")).to eq(true)
  end

  it "opens a new file with text in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"

    expect {
      described_class.open("newfile.txt", content: "Some text",
                          command: editor_command)
    }.to output("Some text").to_stdout_from_any_process

    expect(::File.read("newfile.txt")).to eq("Some text")
  end
end
