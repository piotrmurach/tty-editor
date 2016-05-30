# encoding: utf-8

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
      [ENV['VISUAL'], ENV['EDITOR'], 'vi', 'emacs']
    end

    # Find available command
    #
    # @param [Array[String]] commands
    #
    # @return [String]
    #
    # @api public
    def self.available(*commands)
      commands = commands.empty? ? executables : commands
      commands.compact.uniq.find { |cmd| exists?(cmd) }
    end

    # Finds command using a configured command(s) or detected shell commands.
    #
    # @param [Array[String]] commands
    #
    # @return [String]
    #
    # @api public
    def self.command(*commands)
      @command = if @command && commands.empty?
        @command
      else
        available(*commands)
      end
    end

    # Open file in system editor
    #
    # @param [String] file
    #   the name of the file
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @return [Object]
    #
    # @api public
    def self.open(*args)
      unless command
        fail CommandInvocationError, 'Please export $VISUAL or $EDITOR'
      end

      editor = self.new(*args)
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

    # Build invocation command for editor
    #
    # @return [String]
    #
    # @api private
    def build
      "#{Editor.command} #{escape_file}"
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

    # Inovke editor command in a shell
    #
    # @raise [TTY::CommandInvocationError]
    #
    # @api private
    def invoke
      command_invocation = build
      status = system(*Shellwords.split(command_invocation))
      return status if status
      fail CommandInvocationError, "`#{command_invocation}` failed with status: #{$? ? $?.exitstatus : nil}"
    end
  end# Editor
end # TTY
