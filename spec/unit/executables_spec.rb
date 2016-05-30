# encoding: utf-8

RSpec.describe TTY::Editor, '#executables' do
  it "returns default executables" do
    expect(TTY::Editor.executables).to be_an(Array)
  end

  it "includes vi in default executables" do
    expect(TTY::Editor.executables).to include('vi')
  end
end
