#!/usr/bin/env ruby

require_relative 'remotedatacli_create.rb'

puts "Cli of RemoteData"

@accept_commands = {
	"create" => "RemoteDataCli::Creator", 
	"add" => "add_handler"
}

def command_usage

	puts 'What\'s command you will use?'

	@accept_commands.each do |command, handler|
		puts "\t#{command}"
	end

end

if ARGV.length == 0
	
	# no argument, what are you want?
	command_usage
	
else

	# find related handler of the command_input
	command_input = ARGV[0].downcase

	if @accept_commands.key?(command_input)

		handler_str = @accept_commands[command_input]
		
		handler = RemoteDataCli::Creator.new('App')
		puts "#{command_input} by #{handler}"

	else

		# no matched command, what are you want?
		command_usage

	end

end