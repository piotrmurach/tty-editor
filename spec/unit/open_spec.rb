# encoding: utf-8

RSpec.describe TTY::Editor, '#open' do
  it 'opens editor with known command' do
    invocable = double(:invocable, run: nil)
    allow(TTY::Editor).to receive(:new).
      with('hello.rb', command: :vim).and_return(invocable)

    TTY::Editor.open('hello.rb', command: :vim)

    expect(TTY::Editor).to have_received(:new).with('hello.rb', command: :vim)
  end

  it 'fails to open editor with unknown command' do
    expect {
      TTY::Editor.open('hello.rb', command: :unknown)
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end
end
