# Change log

## [v0.7.0] - unreleased

### Added
* Add :enable_color option to allow control over editor menu colouring

### Changed
* Change to search default editors when command and env variables checks fail

### Fixed
* Fix Editor#exist? to correctly check command with an absolute path

## [v0.6.0] - 2020-09-22

### Added
* Add ability to edit multiple files
* Add ability to configure input and output
* Add :raise_on_failure configuration option to control editor failure to run
* Add :show_menu configuration option to disable editor menu choice
* Add :prompt to configure an editor choice menu prompt

### Changed
* Change Editor#exist? to use direct path env var search
* Change Editor#new to stop accepting filename and text arguments
* Change Editor#new to select available text editors
* Change Editor#open to accept keyword arguments
* Change to stop raising when editor command cannot be run and return false instead
* Remove tty-which dependency
* Update tty-prompt dependency

### Fixed
* Fix to allow setting editor commands with flags

## [v0.5.1] - 2019-08-06

### Changed
* Change to update tty-prompt dependency
* Change to relax bundler & rake version requirement

## [v0.5.0] - 2018-12-18

### Changed
* Change to update and relax tty-prompt & tty-which constraints

## [v0.4.1] - 2018-08-29

### Changed
* Update tty-prompt dependency

## [v0.4.0] - 2018-04-14

### Changed
* Update tty-prompt dependency
* Change to freeze all strings

## [v0.3.0] - 2018-01-06

### Changed
* Update tty-prompt dependency
* Change gemspec to require ruby >= 2.0.0

## [v0.2.1] - 2017-09-18

### Changed
* Change to update tty-prompt dependency

## [v0.2.0] - 2017-03-26

### Added
* Add support for Windows by using notepad editor
* Add :content option to Editor#open to distinguish between opening
  a file with/without content

### Changed
* Change to prioritise $VISUAL & $EDITOR env variables
* Change to stop generating tempfiles when open without filename or content
* Change loading paths
* Change dependencies

### Fixed
* Fix windows shell escaping

## [v0.1.2] - 2017-02-06

### Fixed
* Fix File namespacing issue

## [v0.1.1] - 2017-01-01

### Fixed
* Fix gemspec summary

## [v0.1.0] - 2017-01-01

* Initial implementation and release

[v0.7.0]: https://github.com/piotrmurach/tty-editor/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/piotrmurach/tty-editor/compare/v0.5.1...v0.6.0
[v0.5.1]: https://github.com/piotrmurach/tty-editor/compare/v0.5.0...v0.5.1
[v0.5.0]: https://github.com/piotrmurach/tty-editor/compare/v0.4.1...v0.5.0
[v0.4.1]: https://github.com/piotrmurach/tty-editor/compare/v0.4.0...v0.4.1
[v0.4.0]: https://github.com/piotrmurach/tty-editor/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/piotrmurach/tty-editor/compare/v0.2.1...v0.3.0
[v0.2.1]: https://github.com/piotrmurach/tty-editor/compare/v0.2.0...v0.2.1
[v0.2.0]: https://github.com/piotrmurach/tty-editor/compare/v0.1.2...v0.2.0
[v0.1.2]: https://github.com/piotrmurach/tty-editor/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/piotrmurach/tty-editor/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/piotrmurach/tty-editor/compare/v0.1.0
