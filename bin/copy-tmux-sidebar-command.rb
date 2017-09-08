#!/usr/bin/env ruby

require 'json'
require 'clipboard'
require_relative 'functions.rb'


commands = get_commands_from_commands_file '~/commands.json'
command_keys = commands.keys

num = 2

num = %x( yad --width 300 --entry --title "Choose the command number" )
num = num.to_i
command = commands[command_keys[num]]

if command.kind_of?(Array)
    command = command.join '; '
end

command = " " + command

Clipboard.copy(command)
