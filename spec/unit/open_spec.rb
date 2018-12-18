# frozen_string_literal: true

require 'fileutils'

RSpec.describe TTY::Editor, '#open' do
  before do
    ::FileUtils.mkdir_p(tmp_path)
  end

  after do
    ::FileUtils.rm_rf(tmp_path)
  end


  it "opens existing file" do
    file = fixtures_path('hello.txt')
    editor = TTY::Editor.new(file, command: :vim)

    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)

    expect(editor).to have_received(:system).with({}, 'vim', file)
  end

  it "opens non-existing file without content" do
    new_file = File.join(tmp_path, 'new.rb')
    editor = TTY::Editor.new(new_file, command: :vim)

    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)

    expect(::File.exist?(new_file)).to eq(true)
    expect(editor).to have_received(:system).with({}, 'vim', new_file)
  end

  it "opens non-existing file with new content" do
    new_file = File.join(tmp_path, 'new.rb')
    editor = TTY::Editor.new(new_file, content: 'Hello Ruby!', command: :vim)

    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)

    expect(::File.read(new_file)).to eq("Hello Ruby!")
    expect(editor).to have_received(:system).with({}, 'vim', new_file)
  end

  it "opens existing file with existing content" do
    file = tmp_path('hello.txt')
    ::File.write(file, "Hello Ruby!\n")
    editor = TTY::Editor.new(file, content: 'more content', command: :vim)

    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)

    expect(::File.read(file)).to eq("Hello Ruby!\nmore content")
    expect(editor).to have_received(:system).with({}, 'vim', file)
  end

  it "opens content in a temp file" do
    tmp_file = StringIO.new
    def tmp_file.path
      'tty-editor-path'
    end
    allow(Tempfile).to receive(:new).and_return(tmp_file)
    allow(tmp_file).to receive(:<<)
    editor = TTY::Editor.new(content: 'Hello Ruby!', command: :vim)

    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)

    expect(editor).to have_received(:system).with({}, 'vim', 'tty-editor-path')
    expect(tmp_file).to have_received(:<<).with('Hello Ruby!')
  end

  it "opens editor without filename or content" do
    editor = TTY::Editor.new(command: :vim)
    allow(editor).to receive(:system).and_return(true)
    expect(editor.open).to eq(true)
    expect(editor).to have_received(:system).with({}, 'vim', '')
  end

  it "fails to open non-file without content" do
    expect {
      TTY::Editor.open(fixtures_path)
    }.to raise_error(ArgumentError, /Don't know how to handle `#{fixtures_path}`./)
  end

  it 'opens file in editor with known command' do
    invocable = double(:invocable, open: nil)
    allow(TTY::Editor).to receive(:new).
      with('hello.rb', command: :vim).and_return(invocable)

    TTY::Editor.open('hello.rb', command: :vim)

    expect(TTY::Editor).to have_received(:new).with('hello.rb', command: :vim)
  end

  it 'fails to open editor with unknown command' do
    expect {
      TTY::Editor.open(fixtures_path('hello.txt'), command: :unknown)
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end
end
