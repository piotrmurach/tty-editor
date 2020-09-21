# frozen_string_literal: true

RSpec.describe TTY::Editor, type: :sandbox do
  it "opens text in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"
    status = nil

    expect {
      status = described_class.open(text: "Some text", command: editor_command)
    }.to output(/Some text/).to_stdout_from_any_process
    expect(status).to eq(true)
  end

  it "opens an existing file in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"
    file = fixtures_path("content.txt")
    status = nil

    expect {
      status = described_class.open(file, command: editor_command)
    }.to output(/one\ntwo\nthree\n/).to_stdout_from_any_process
    expect(status).to eq(true)
  end

  it "opens a new file in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"

    status = described_class.open("newfile.txt", command: editor_command)

    expect(status).to eq(true)
    expect(::File.exist?("newfile.txt")).to eq(true)
  end

  it "opens a new file with text in an editor" do
    editor_command = "ruby #{fixtures_path("cat.rb")}"
    status = nil

    expect {
      status = described_class.open("newfile.txt", text: "Some text",
                                    command: editor_command)
    }.to output(/Some text/).to_stdout_from_any_process

    expect(status).to eq(true)
    expect(::File.read("newfile.txt")).to eq("Some text")
  end

  it "opens multiple existing files in an editor" do
    editor_command = "ruby #{fixtures_path("echo.rb")}"
    text_file = fixtures_path("content.txt")
    cat_file = fixtures_path("cat.rb")

    expect {
      described_class.open(text_file, cat_file, command: editor_command)
    }.to output(/#{text_file} #{cat_file}/).to_stdout_from_any_process
  end

  it "opens multiple files, existing and new, in an editor" do
    editor_command = "ruby #{fixtures_path("echo.rb")}"
    text_file = fixtures_path("content.txt")

    expect {
      described_class.open(text_file, "newfile.txt", command: editor_command)
    }.to output(/#{text_file} newfile\.txt/).to_stdout_from_any_process

    expect(::File.read(text_file)).to eq("one\ntwo\nthree\n")
    expect(::File.read("newfile.txt")).to eq("")
  end

  it "opens multiple new files with a text in an editor" do
    editor_command = "ruby #{fixtures_path("echo.rb")}"

    expect {
      described_class.open("newfile1.txt", "newfile2.txt", text: "Some text",
                           command: editor_command)
    }.to output(/newfile1\.txt newfile2\.txt/).to_stdout_from_any_process

    expect(::File.read("newfile1.txt")).to eq("Some text")
    expect(::File.read("newfile2.txt")).to eq("Some text")
  end

  it "shows an editor choice menu and selects second option" do
    file = fixtures_path("content.txt")
    cat = "ruby #{fixtures_path("cat.rb")}"
    echo = "ruby #{fixtures_path("echo.rb")}"
    status = nil
    input = StringIO.new
    output = StringIO.new

    expected_output = [
      "Select an editor? \n",
      "  \e[32m1) #{cat}\e[0m\n",
      "  2) #{echo}\n",
      "  Choose 1-2 [1]: ",
      "\e[2K\e[1G\e[1A" * 3,
      "\e[2K\e[1G\e[J",
      "Select an editor? \n",
      "  1) #{cat}\n",
      "  \e[32m2) #{echo}\e[0m\n",
      "  Choose 1-2 [1]: 2",
      "\e[2K\e[1G\e[1A" * 3,
      "\e[2K\e[1G\e[J",
      "Select an editor? \e[32m#{echo}\e[0m\n",
      "\e[1A\e[2K\e[1G",
    ].join

    expect {
      input << "2\n"
      input.rewind

      editor = described_class.new(command: [cat, echo], input: input,
                                   output: output, env: {"TTY_TEST" => "true"})
      status = editor.open(file)
    }.to output(/#{file}/).to_stdout_from_any_process

    expect(output.string).to eq(expected_output)
    expect(status).to eq(true)
  end

  it "shows a choice menu with a custom prompt and selects the default editor" do
    file = fixtures_path("content.txt")
    cat = "ruby #{fixtures_path("cat.rb")}"
    echo = "ruby #{fixtures_path("echo.rb")}"
    status = nil
    input = StringIO.new
    output = StringIO.new

    expected_output = [
      "Which one do you fancy? \n",
      "  \e[32m1) #{cat}\e[0m\n",
      "  2) #{echo}\n",
      "  Choose 1-2 [1]: ",
      "\e[2K\e[1G\e[1A" * 3,
      "\e[2K\e[1G\e[J",
      "Which one do you fancy? \e[32m#{cat}\e[0m\n",
      "\e[1A\e[2K\e[1G",
    ].join

    expect {
      input << "\n"
      input.rewind

      editor = described_class.new(command: [cat, echo], input: input,
                                   prompt: "Which one do you fancy?",
                                   output: output, env: {"TTY_TEST" => "true"})
      status = editor.open(file)
    }.to output(/one\ntwo\nthree\n/).to_stdout_from_any_process

    expect(output.string).to eq(expected_output)
    expect(status).to eq(true)
  end
end
