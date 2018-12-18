<div align="center">
  <a href="https://piotrmurach.github.io/tty" target="_blank"><img width="130" src="https://cdn.rawgit.com/piotrmurach/tty/master/images/tty.png" alt="tty logo" /></a>
</div>

# TTY::Editor [![Gitter](https://badges.gitter.im/Join%20Chat.svg)][gitter]

[![Gem Version](https://badge.fury.io/rb/tty-editor.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/tty-editor.svg?branch=master)][travis]
[![Build status](https://ci.appveyor.com/api/projects/status/yw4guy16meq5wkee?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/0afb9e75eef4ae4615c6/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-editor/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty-editor.svg?branch=master)][inchpages]

[gitter]: https://gitter.im/piotrmurach/tty
[gem]: http://badge.fury.io/rb/tty-editor
[travis]: http://travis-ci.org/piotrmurach/tty-editor
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-editor
[codeclimate]:https://codeclimate.com/github/piotrmurach/tty-editor/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-editor
[inchpages]: http://inch-ci.org/github/piotrmurach/tty-editor

> Opens a file or text in the user's preferred editor.

**TTY::Editor** provides independent component for [TTY](https://github.com/piotrmurach/tty) toolkit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tty-editor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty-editor

## Usage

To edit a file in default editor:

```ruby
TTY::Editor.open('hello.rb')
```

To edit content in a default editor:

```ruby
TTY::Editor.open(content: "some text")
```

You can also set your preferred editor command:

```ruby
TTY::Editor.open('hello.rb', command: :vim)
```

Also, the `VISUAL` or `EDITOR` shell environment variables take precedence when auto detecting available editors.

## Interface

### open

If you wish to open editor with no file or content do:

```ruby
TTY::Editor.open
```

To open a file at a path pass it as a first argument:

```ruby
TTY::Editor.open('../README.md')
```

When editor successfully opens file or content then `true` is returned.

If the editor cannot be opened, a `TTY::Editor::CommandInvocation` error is raised.

In order to open text content inside an editor do:

```ruby
TTY::Editor.open(content: 'text')
```

You can also provide filename that will be created with specified content before editor is opened:

```ruby
TTY::Editor.open('new.rb', content: 'text')
```

If you open a filename with already existing content then new content gets appended at the end of the file.

### :env

Use `:env` key to forward environment variables to  the editor.

```ruby
TTY::Editor.open('hello.rb', env: {"FOO" => "bar"})
```

### :command

You can force to always use a specific editor by passing `:command` option:

```ruby
TTY::Editor.open('hello.rb', command: :vim)
```

To specify more than one command, and hence give a user a choice do:

```ruby
TTY::Editor.open('hello.rb') do |editor|
  editor.command :vim, :emacs
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotrmurach/tty-editor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2017 Piotr Murach. See LICENSE for further details.
