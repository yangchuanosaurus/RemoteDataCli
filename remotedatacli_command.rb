require_relative 'remotedatacli_create.rb'
require_relative 'remotedatacli_add_action.rb'

module RemoteDataCli

	RemoteDataCli::Accept_commands = {
		"create" => "RemoteDataCli::Creator", 
		"add" => "RemoteDataCli::AddAction"
	}

	RemoteDataCli::Accept_commands_argv_size = {
		"create" => 2, 
		"add" => 3
	}

	class Command
		#attr_reader :

		def initialize(*argv)
			@argv = argv
			@command_input = @argv[0].downcase
		end

		def handler
			if RemoteDataCli::Accept_commands.key?(@command_input)
				
				expected_var_size = RemoteDataCli::Accept_commands_argv_size[@command_input]

				if @argv.size >= expected_var_size
					# valid argv size
					handler_str = RemoteDataCli::Accept_commands[@command_input]
					create_handler_instance(handler_str)
				else
					puts "Invalid size of argv of command:`#{@command_input}`"
				end
				
			else

			end
			
		end

		def action
			@command_input
		end

		def parameters
			@argv[1..-1]
		end

		private
		  def create_handler_instance(clazz_str)
		  	clazz = clazz_str.split('::').inject(Object) { |o, c| o.const_get c }
		  	clazz.new(self)
		  end

	end

end

# command = RemoteDataCli::Command.new("create", "app")
# handle = command.handler
# handle.execute

# command = RemoteDataCli::Command.new("add", "events", "post")
# handle = command.handler
# handle.execute
