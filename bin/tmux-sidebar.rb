#!/usr/bin/env ruby

require 'json'
require_relative 'functions.rb'

def get_config
    file_name = "#{Dir.home}/commands.json"
    file = File.read(file_name)
    config = JSON.parse(file)
    config['tmux-sidebar']
end

commands = get_commands_from_commands_file '~/commands.json'
config = get_config

process_id = %x( tmux list-panes -F '\#{pane_active} \#{pane_pid}' | grep '^1' | cut -d ' ' -f 2 )
process_id.chomp!

command = %x( ps -p #{process_id} -o args --no-headers )
parent_command = %x( ps --ppid #{process_id} -o args --no-headers)


puts "Command:        #{command}"
puts "Parent command: #{parent_command}"
puts ""

config.each do |key, value|
    match = Regexp.new(key).match(command)
    # puts "key #{key} => command #{command}, match => #{match}"
    match = Regexp.new(key).match(parent_command) if not match
    # puts "key #{key} => command #{parent_command}, match => #{match}"
    if match
        commands.each_with_index do |(command_key, command_value), command_index|
            command_match = Regexp.new(value).match(command_key)

            if command_match
                puts "#{command_index}: #{command_key}"
                puts "   => #{command_value}"
                puts ""
            end
        end
    end

end
