# frozen_string_literal: true

require "tty-prompt"
require "tempfile"
require "fileutils"
require "shellwords"

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
      ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |dir|
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

    # List possible command line text editors
    #
    # @return [Array[String]]
    #
    # @api public
    def self.executables
      ["nano", "nano-tiny", "notepad", "vim", "vi", "emacs",
       "pico", "sublime", "mate -w"]
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
                commands
              elsif from_env.any?
                [from_env.first]
              else
                executables
              end
      execs.compact.map(&:strip).reject(&:empty?).uniq
           .select { |exec| exist?(exec.split.first) }
    end

    # Open file in system editor
    #
    # @example
    #   TTY::Editor.open("/path/to/filename")
    #
    # @param [String] filename
    #   the name of the file
    # @param [String] :command
    #   the editor command to use, by default auto detects
    # @param [String] :contet
    #   the content to edit
    # @param [Hash] :env
    #   environment variables to forward to the editor
    #
    # @return [Object]
    #
    # @api public
    def self.open(filename = nil, **options)
      editor = new(filename, **options)

      yield(editor) if block_given?

      editor.open
    end

    # Initialize an Editor
    #
    # @param [String] filenmame
    # @param [String] :command
    #   the editor command to use, by default auto detects
    # @param [String] :contet
    #   the content to edit
    # @param [Hash] :env
    #   environment variables to forward to the editor
    #
    # @api public
    def initialize(filename = nil, command: nil, content: nil, env: {})
      @filename = filename
      @tempfile = nil
      @env      = env
      @command  = nil

      if !filename.nil?
        if ::File.exist?(filename) && !content.nil?
          raise InvalidArgumentError,
                "cannot give a path to an existing file and text at the same time."
        elsif ::File.exist?(filename) && !::FileTest.file?(filename)
          raise InvalidArgumentError, "don't know how to handle `#{filename}`. " \
                                      "Please provide a file path or text"
        elsif !::File.exist?(filename)
          ::File.write(filename, content || "")
        end
      elsif !content.nil?
        @tempfile = create_tempfile(content)
        @filename = @tempfile.path
      end

      command(*Array(command))
    end

    # Read or update environment vars
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
              "Could not find editor to use. Please specify $VISUAL or $EDITOR"
      end
      @command = choose_exec_from(execs)
    end

    # Build command path to invoke
    #
    # @return [String]
    #
    # @api public
    def command_path
      "#{command} #{escape_file}"
    end

    # Run editor command in a shell
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @api private
    def open
      status = system(env, *Shellwords.split(command_path))
      return status if status
      raise CommandInvocationError,
            "`#{command_path}` failed with status: #{$? ? $?.exitstatus : nil}"
    ensure
      @tempfile.unlink if @tempfile
    end

    private

    # Create tempfile with content
    #
    # @param [String] content
    #
    # @return [Tempfile]
    #
    # @api private
    def create_tempfile(content)
      tempfile = Tempfile.new("tty-editor")
      tempfile << content
      tempfile.flush
      tempfile.close
      tempfile
    end

    # @api private
    def choose_exec_from(execs)
      if execs.size > 1
        prompt = TTY::Prompt.new
        prompt.enum_select("Select an editor?", execs)
      else
        execs[0]
      end
    end

    # Escape file path
    #
    # @api private
    def escape_file
      Shellwords.shellescape(@filename)
    end
  end # Editor
end # TTY
