# encoding: utf-8

require 'tty-prompt'
require 'tty-platform'
require 'tty-which'
require 'shellwords'

require 'tty/editor/version'

module TTY
  # A class responsible for launching an editor
  #
  # @api private
  class Editor
    # Raised when command cannot be invoked
    class CommandInvocationError < RuntimeError; end

    # Raised when not editor found
    class EditorNotFoundError < RuntimeError; end

    @command = nil

    def self.exists?(path)
      !TTY::Which.which(path).nil?
    end

    # List possible executable for editor command
    #
    # @return [Array[String]]
    #
    # @api private
    def self.executables
      [ENV['VISUAL'], ENV['EDITOR'],
       'vim', 'vi', 'emacs', 'nano', 'nano-tiny', 'pico', 'mate -w']
    end

    # Find available command
    #
    # @param [Array[String]] commands
    #
    # @return [Array[String]]
    #
    # @api public
    def self.available(*commands)
      commands = commands.empty? ? executables : commands
      commands.compact.uniq.select { |cmd| exists?(cmd) }
    end

    # Finds command using a configured command(s) or detected shell commands.
    #
    # @param [Array[String]] commands
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @return [String]
    #
    # @api public
    def self.command(*commands)
      if @command && commands.empty?
        @command
      else
        execs = available(*commands)
        if execs.empty?
          fail EditorNotFoundError,
               'Could not find editor to use. Please specify $VISUAL or $EDITOR'
        else
          exec = if execs.size > 1
                   prompt = TTY::Prompt.new
                   prompt.enum_select('Select an editor?', execs)
                 else
                   execs[0]
                 end
          @command = TTY::Which.which(exec)
        end
      end
    end

    # Open file in system editor
    #
    # @param [String] file
    #   the name of the file
    #
    #
    # @return [Object]
    #
    # @api public
    def self.open(*args)
      editor = new(*args)

      yield(editor) if block_given?

      editor.invoke
    end

    # Initialize an Editor
    #
    # @param [String] file
    #
    # @api public
    def initialize(*args)
      @env      = args.first.is_a?(Hash) ? args.shift : {}
      @options  = args.last.is_a?(Hash) ? args.pop : {}
      @filename = args.shift
    end

    # Escape file path
    #
    # @api private
    def escape_file
      if TTY::Platform.unix?
        Shellwords.shellescape(@filename)
      elsif TTY::Platform.windows?
        @filename.gsub(/\//, '\\')
      else
        @filename
      end
    end

    # Build command path to invoke
    #
    # @return [String]
    #
    # @api private
    def command_path
      "#{self.class.command} #{escape_file}"
    end

    # Inovke editor command in a shell
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @api private
    def run
      status = system(*Shellwords.split(command_path))
      return status if status
      fail CommandInvocationError,
           "`#{command_path}` failed with status: #{$? ? $?.exitstatus : nil}"
    end
  end # Editor
end # TTY
