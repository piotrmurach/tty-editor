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

## Contents

* [1. Usage](#1-usage)
* [2. API](#2-api)
  * [2.1 new](#21-new)
    * [2.1.1 :command](#211-command)
    * [2.1.2 :env](#212-env)
    * [2.1.3 :raise_on_failure](#213-raise_on_failure)
  * [2.2 open](#22-open)

## 1. Usage

To edit a file in a default text editor do:

```ruby
TTY::Editor.open("/path/to/file")
```

To edit text in a default editor:

```ruby
TTY::Editor.open(text: "Some text")
```

You can also set your preferred editor command(s):

```ruby
TTY::Editor.open("/path/to/file", command: "vim -f")
```

Note that the `VISUAL` or `EDITOR` shell environment variables take precedence when auto detecting available editors.

## 2. API

### 2.1 new

Instantiation of an editor will trigger automatic search for available command-line editors:

```ruby
editor = TTY::Editor.new
```

You can change default search with the `:command` keyword argument.

#### 2.1.1 :command

You can force to always use a specific editor by passing `:command` option:

```ruby
editor = TTY::Editor.new(command: "vim")
```

Or you can specify multiple commands and give a user a choice:

```ruby
editor = TTY::Editor.new(command: ["vim", "emacs"])
```

The class-level `open` method accepts the same parameters:

```ruby
TTY::Editor.open("/path/to/file", command: "vim")
```

#### 2.1.2 :env

Use `:env` key to forward environment variables to the text editor launch command:

```ruby
TTY::Editor.new(env: {"FOO" => "bar"})
```

The class-level `open` method accepts the same parameters:

```ruby
TTY::Editor.open("/path/to/file", env: {"FOO" => "bar"})
```

#### 2.1.3 :raise_on_failure

By default when editor fails to open a `false` status is returned:

```ruby
TTY::Editor.open("/path/to/unknown/file") # => false
```

By using `:raise_on_failure`, you can raise `TTY::Editor::CommandInvocationError`:

```
editor = TTY::Editor.new(raise_on_failure: true)
editor.open("/path/to/unknown/file")
# => raises TTY::Editor::ComandInvocationError
```

### 2.2 open

If you wish to open editor with no file or content do:

```ruby
TTY::Editor.open
```

To open a file at a path pass it as a first argument:

```ruby
TTY::Editor.open("../README.md")
# => true
```

When editor successfully opens file or content then `true` is returned, `false` otherwise. You can change this with `:raise_on_failure` keyword to raise a `TTY::Editor::CommandInvocation` error when an editor cannot be opened.

In order to open text content inside an editor do:

```ruby
TTY::Editor.open(text: "Some text")
```

You can also provide filename that will be created with specified content before editor is opened:

```ruby
TTY::Editor.open("/path/to/new-file', text: "Some text")
```

If you open a filename with already existing content then new content gets appended at the end of the file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotrmurach/tty-editor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2017 Piotr Murach. See LICENSE for further details.
