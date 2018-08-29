# frozen_string_literal: true

require 'tty-prompt'
require 'tty-which'
require 'tempfile'
require 'fileutils'
require 'shellwords'

require_relative 'editor/version'

module TTY
  # A class responsible for launching an editor
  #
  # @api public
  class Editor
    # Raised when command cannot be invoked
    class CommandInvocationError < RuntimeError; end

    # Raised when editor cannot be found
    class EditorNotFoundError < RuntimeError; end

    # Check if editor exists
    #
    # @return [Boolean]
    #
    # @api private
    def self.exist?(cmd)
      TTY::Which.exist?(cmd)
    end

    # Check if Windowz
    #
    # @return [Boolean]
    #
    # @api public
    def self.windows?
      ::File::ALT_SEPARATOR == "\\"
    end

    # Check editor from environment variables
    #
    # @return [Array[String]]
    #
    # @api public
    def self.from_env
      [ENV['VISUAL'], ENV['EDITOR']].compact
    end

    # List possible executable for editor command
    #
    # @return [Array[String]]
    #
    # @api public
    def self.executables
      ['vim', 'vi', 'emacs', 'nano', 'nano-tiny', 'pico', 'mate -w']
    end

    # Find available command
    #
    # @param [Array[String]] commands
    #   the commands to use intstead of defaults
    #
    # @return [Array[String]]
    #
    # @api public
    def self.available(*commands)
      return commands unless commands.empty?

      if !from_env.all?(&:empty?)
        [from_env.find { |e| !e.empty? }]
      elsif windows?
        ['notepad']
      else
        executables.uniq.select(&method(:exist?))
      end
    end

    # Open file in system editor
    #
    # @example
    #   TTY::Editor.open('filename.rb')
    #
    # @param [String] file
    #   the name of the file
    #
    # @return [Object]
    #
    # @api public
    def self.open(*args)
      editor = new(*args)

      yield(editor) if block_given?

      editor.open
    end

    # Initialize an Editor
    #
    # @param [String] file
    # @param [Hash[Symbol]] options
    # @option options [Hash] :command
    #   the editor command to use, by default auto detects
    # @option options [Hash] :env
    #   environment variables to forward to the editor
    #
    # @api public
    def initialize(*args, **options)
      @filename = args.unshift.first
      @env      = options.fetch(:env) { {} }
      @command  = options[:command]
      if @filename
        if ::File.exist?(@filename) && !::FileTest.file?(@filename)
          raise ArgumentError, "Don't know how to handle `#{@filename}`. " \
                               "Please provida a file path or content"
        elsif ::File.exist?(@filename) && !options[:content].to_s.empty?
          ::File.open(@filename, 'a') { |f| f.write(options[:content]) }
        elsif !::File.exist?(@filename)
          ::File.write(@filename, options[:content])
        end
      elsif options[:content]
        @filename = tempfile_path(options[:content])
      end
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
              'Could not find editor to use. Please specify $VISUAL or $EDITOR'
      end
      exec = choose_exec_from(execs)
      @command = TTY::Which.which(exec.to_s)
    end

    # @api private
    def choose_exec_from(execs)
      if execs.size > 1
        prompt = TTY::Prompt.new
        prompt.enum_select('Select an editor?', execs)
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

    # Build command path to invoke
    #
    # @return [String]
    #
    # @api private
    def command_path
      "#{command} #{escape_file}"
    end

    # Create tempfile with content
    #
    # @param [String] content
    #
    # @return [String]
    # @api private
    def tempfile_path(content)
      tempfile = Tempfile.new('tty-editor')
      tempfile << content
      tempfile.flush
      unless tempfile.nil?
        tempfile.close
      end
      tempfile.path
    end

    # Inovke editor command in a shell
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @api private
    def open
      status = system(env, *Shellwords.split(command_path))
      return status if status
      fail CommandInvocationError,
           "`#{command_path}` failed with status: #{$? ? $?.exitstatus : nil}"
    end
  end # Editor
end # TTY
