#!/usr/bin/env ruby

require_relative 'remotedatacli_command'

puts "Cli of RemoteData"

def command_usage

	puts 'What\'s command you will use?'

	RemoteDataCli::Accept_commands.each do |command, handler|
		puts "\t#{command}"
	end

end

if ARGV.length == 0
	
	# no argument, what are you want?
	command_usage
	
else
	
	# find related handler of the command_input
	command = RemoteDataCli::Command.new(*ARGV)
	command_handler = command.handler

	if !command_handler.nil?

		puts "\t#{command_handler.execute}"

	else

		# no matched command, what are you want?
		command_usage

	end

end
