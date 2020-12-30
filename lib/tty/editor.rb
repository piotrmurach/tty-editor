# frozen_string_literal: true

require "fileutils"
require "shellwords"
require "tempfile"
require "tty-prompt"

require_relative "editor/version"

module TTY
  # A class responsible for launching an editor
  #
  # @api public
  class Editor
    Error = Class.new(StandardError)

    # Raised when user provides unnexpected or incorrect argument
    InvalidArgumentError = Class.new(Error)

    # Raised when command cannot be invoked
    class CommandInvocationError < RuntimeError; end

    # Raised when editor cannot be found
    class EditorNotFoundError < RuntimeError; end

    # List possible command line text editors
    #
    # @return [Array[String]]
    #
    # @api public
    EXECUTABLES = [
      "nano -w", "notepad", "vim", "vi", "emacs",
      "code", "subl -n -w", "mate -w", "atom",
      "pico", "qe", "mg", "jed"
    ].freeze

    # Check if editor command exists
    #
    # @example
    #   exist?("vim") # => true
    #
    # @return [Boolean]
    #
    # @api private
    def self.exist?(command)
      exts = ENV.fetch("PATHEXT", "").split(::File::PATH_SEPARATOR)
      ENV.fetch("PATH", "").split(::File::PATH_SEPARATOR).any? do |dir|
        file = ::File.join(dir, command)
        ::File.exist?(file) || exts.any? { |ext| ::File.exist?("#{file}#{ext}") }
      end
    end

    # Check editor from environment variables
    #
    # @return [Array[String]]
    #
    # @api public
    def self.from_env
      [ENV["VISUAL"], ENV["EDITOR"]].compact
    end

    # Find available text editors
    #
    # @param [Array[String]] commands
    #   the commands to use intstead of defaults
    #
    # @return [Array[String]]
    #   the existing editor commands
    #
    # @api public
    def self.available(*commands)
      execs = if !commands.empty?
                commands.map(&:to_s)
              elsif from_env.any?
                [from_env.first]
              else
                EXECUTABLES
              end
      execs.compact.map(&:strip).reject(&:empty?).uniq
           .select { |exec| exist?(exec.split.first) }
    end

    # Open file in system editor
    #
    # @example
    #   TTY::Editor.open("/path/to/filename")
    #
    # @example
    #   TTY::Editor.open("file1", "file2", "file3")
    #
    # @example
    #   TTY::Editor.open(text: "Some text")
    #
    # @param [Array<String>] files
    #   the files to open in an editor
    # @param [String] :command
    #   the editor command to use, by default auto detects
    # @param [String] :text
    #   the text to edit in an editor
    # @param [Hash] :env
    #   environment variables to forward to the editor
    #
    # @return [Object]
    #
    # @api public
    def self.open(*files, text: nil, **options, &block)
      editor = new(**options, &block)
      editor.open(*files, text: text)
    end

    # Initialize an Editor
    #
    # @param [String] :command
    #   the editor command to use, by default auto detects
    # @param [Hash] :env
    #   environment variables to forward to the editor
    # @param [IO] :input
    #   the standard input
    # @param [IO] :output
    #   the standard output
    # @param [Boolean] :raise_on_failure
    #   whether or not raise on command failure, false by default
    # @param [Boolean] :show_menu
    #   whether or not show commands menu, true by default
    # @param [Boolean] enable_color
    #   disable or force prompt coloring, defaults to nil
    #
    # @api public
    def initialize(command: nil, raise_on_failure: false, show_menu: true,
                   prompt: "Select an editor?", env: {}, enable_color: nil,
                   input: $stdin, output: $stdout, &block)
      @env = env
      @command = nil
      @input = input
      @output = output
      @raise_on_failure = raise_on_failure
      @enable_color = enable_color
      @show_menu = show_menu
      @prompt = prompt

      block.(self) if block

      command(*Array(command))
    end

    # Read or update environment vars
    #
    # @return [Hash]
    #
    # @api public
    def env(value = (not_set = true))
      return @env if not_set

      @env = value
    end

    # Finds command using a configured command(s) or detected shell commands.
    #
    # @param [Array[String]] commands
    #   the optional command to use, by default auto detecting
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @return [String]
    #
    # @api public
    def command(*commands)
      return @command if @command && commands.empty?

      execs = self.class.available(*commands)
      if execs.empty?
        raise EditorNotFoundError,
              "could not find a text editor to use. Please specify $VISUAL or "\
              "$EDITOR or install one of the following editors: " \
              "#{EXECUTABLES.map { |ed| ed.split.first }.join(", ")}."
      end
      @command = choose_exec_from(execs)
    end

    # Run editor command in a shell
    #
    # @param [Array<String>] files
    #   the files to open in an editor
    # @param [String] :text
    #   the text to edit in an editor
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @return [Boolean]
    #   whether editor command suceeded or not
    #
    # @api private
    def open(*files, text: nil)
      validate_arguments(files, text)
      text_written = false

      filepaths = files.reduce([]) do |paths, filename|
        if !::File.exist?(filename)
          ::File.write(filename, text || "")
          text_written = true
        end
        paths + [filename]
      end

      if !text.nil? && !text_written
        tempfile = create_tempfile(text)
        filepaths << tempfile.path
      end

      run(filepaths)
    ensure
      tempfile.unlink if tempfile
    end

    private

    # Run editor command with file arguments
    #
    # @param [Array<String>] filepaths
    #   the file paths to open in an editor
    #
    # @return [Boolean]
    #   whether command succeeded or not
    #
    # @api private
    def run(filepaths)
      command_path = "#{command} #{filepaths.shelljoin}"
      status = system(env, *Shellwords.split(command_path))
      if @raise_on_failure && !status
        raise CommandInvocationError,
              "`#{command_path}` failed with status: #{$? ? $?.exitstatus : nil}"
      end
      !!status
    end

    # Check if filename and text arguments are valid
    #
    # @raise [InvalidArgumentError]
    #
    # @api private
    def validate_arguments(files, text)
      return if files.empty?

      if files.all? { |file| ::File.exist?(file) } && !text.nil?
        raise InvalidArgumentError,
              "cannot give a path to an existing file and text at the same time."
      elsif filename = files.find { |file| ::File.exist?(file) && !::FileTest.file?(file) }
        raise InvalidArgumentError, "don't know how to handle `#{filename}`. " \
                                    "Please provide a file path or text"
      end
    end

    # Create tempfile with text
    #
    # @param [String] text
    #
    # @return [Tempfile]
    #
    # @api private
    def create_tempfile(text)
      tempfile = Tempfile.new("tty-editor")
      tempfile << text
      tempfile.flush
      tempfile.close
      tempfile
    end

    # Render an editor selection prompt to the terminal
    #
    # @return [String]
    #   the chosen editor
    #
    # @api private
    def choose_exec_from(execs)
      if @show_menu && execs.size > 1
        prompt = TTY::Prompt.new(input: @input, output: @output, env: @env,
                                 enable_color: @enable_color)
        exec = prompt.enum_select(@prompt, execs)
        @output.print(prompt.cursor.up + prompt.cursor.clear_line)
        exec
      else
        execs[0]
      end
    end
  end # Editor
end # TTY
