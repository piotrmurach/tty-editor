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
    status = nil

    expect {
      status = described_class.open(content: "Some text", command: editor_command)
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
      status = described_class.open("newfile.txt", content: "Some text",
                                    command: editor_command)
    }.to output(/Some text/).to_stdout_from_any_process

    expect(status).to eq(true)
    expect(::File.read("newfile.txt")).to eq("Some text")
  end

  it "shows an editor choice menu and selects second option" do
    file = fixtures_path("content.txt")
    cat = "ruby #{fixtures_path("cat.rb")}"
    echo = "ruby #{fixtures_path("echo.rb")}"
    status = nil

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
      "#{file}\n"
    ].join

    expect {
      stub_input "2\n" do
        status = described_class.open(file, command: [cat, echo])
      end
    }.to output(expected_output).to_stdout_from_any_process
    expect(status).to eq(true)
  end
end
