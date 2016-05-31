# encoding: utf-8

RSpec.describe TTY::Editor, '#open' do
  it 'fails to open editor' do
    allow(TTY::Editor).to receive(:command).and_return(nil)
    expect {
      TTY::Editor.open('hello.rb')
    }.to raise_error(TTY::Editor::CommandInvocationError)
  end

  it 'opens editor' do
    invocable = double(:invocable, run: nil)
    allow(TTY::Editor).to receive(:command).and_return('vim')
    allow(TTY::Editor).to receive(:new).with('hello.rb').and_return(invocable)

    TTY::Editor.open('hello.rb')

    expect(TTY::Editor).to have_received(:new).with('hello.rb')
  end
end
