<div align="center">
  <a href="https://ttytoolkit.org" target="_blank"><img width="130" src="https://github.com/piotrmurach/tty/raw/master/images/tty.png" alt="TTY Toolkit logo" /></a>
</div>

# TTY::Editor [![Gitter](https://badges.gitter.im/Join%20Chat.svg)][gitter]

[![Gem Version](https://badge.fury.io/rb/tty-editor.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/tty-editor/workflows/CI/badge.svg?branch=master)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/yw4guy16meq5wkee?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/0afb9e75eef4ae4615c6/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-editor/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty-editor.svg?branch=master)][inchpages]

[gitter]: https://gitter.im/piotrmurach/tty
[gem]: http://badge.fury.io/rb/tty-editor
[gh_actions_ci]: https://github.com/piotrmurach/tty-editor/actions?query=workflow%3ACI
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-editor
[codeclimate]:https://codeclimate.com/github/piotrmurach/tty-editor/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-editor
[inchpages]: http://inch-ci.org/github/piotrmurach/tty-editor

> Opens a file or text in the user's preferred editor.

**TTY::Editor** provides independent component for [TTY](https://github.com/piotrmurach/tty) toolkit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tty-editor"
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
    * [2.1.4 :prompt](#214-prompt)
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

You can also open multiple existing and/or new files:

```ruby
TTY::Editor.open("file_1", "file_2", "new_file_3")
```

Note that the `VISUAL` or `EDITOR` shell environment variables take precedence when auto detecting available editors.

You can also set your preferred editor command(s) and ignore `VISUAL` and `EDITOR` as well as other user preferences:

```ruby
TTY::Editor.open("/path/to/file", command: "vim -f")
```

When `VISUAL` or `EDITOR` are not specified, a selection menu will be presented to the user.

For example, if an user has `vim`, `emacs` and `code` editors available on their system, they will see the following menu:

```
# Select an editor?
#   1) vim
#   2) emacs
#   3) code
#   Choose 1-2 [1]:
```

You can further customise this behaviour with [:prompt](#214-prompt).

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

Alternatively, you can use `:raise_on_failure` to raise an error on failure to open a file.

The `TTY::Editor::CommandInvocationError` will be raised anytime an editor fails to open a file:

```ruby
editor = TTY::Editor.new(raise_on_failure: true)
editor.open("/path/to/unknown/file")
# => raises TTY::Editor::ComandInvocationError
```

#### 2.1.4 :prompt

When more than one editor is available and user hasn't specified their preferred choice via `VISUAL` or `EDITOR` variables, a selection menu is presented.

For example, when `vim`, `emacs` and `code` executable exists on the system, the following menu will be displayed:

```
# Select an editor?
#   1) vim
#   2) emacs
#   3) code
#   Choose 1-2 [1]:
```

If you would like to change the menu prompt use `:prompt` keyword:

```ruby
editor = TTY::Editor.new(prompt: "Which one do you fancy?")
editor.open("/path/to/file")
```

This may produce the following in the terminal:

```
# Which one do you fancy?
#   1) vim
#   2) emacs
#   3) code
#   Choose 1-2 [1]:
```

### 2.2 open

There is a class-level and instance-level `open` method. These are equivalent:

```ruby
editor = TTY::Editor.new
editor.open(...)
# or
TTY::Editor.open(...)
```

Creating `TTY::Editor` instance means that the search for a command editor will be performed only once. Then the editor command will be shared between invocations of `open` call.

Conversely, the class-level `open` method will search for an editor each time it is invoked.

The following examples of using the `open` method apply to both the instance and class level invocations.

If you wish to open an editor without giving a file or content do:

```ruby
TTY::Editor.open
```

To open a file, pass a path as an argument to `open`:

```ruby
TTY::Editor.open("../README.md")
# => true
```

When editor successfully opens a file or content then `true` is returned, `false` otherwise.

You can change this with `:raise_on_failure` keyword to raise a `TTY::Editor::CommandInvocation` error when an editor cannot be opened.

In order to open text content inside an editor use `:text` keyword like so:

```ruby
TTY::Editor.open(text: "Some text")
```

You can also provide filename that will be created with specified content before editor is opened:

```ruby
TTY::Editor.open("/path/to/new-file", text: "Some text")
```

If you open a filename with already existing content then the new content will be appended at the end of the file.

You can also open multiple existing and non-existing files providing them as consecutive arguments:

```ruby
TTY::Editor.open("file_1", "file_2", "new_file_3")
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
