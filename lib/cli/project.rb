# 
module RemoteDataCli

	# Project
	class Project

		def initialize(app_name)
			@app_name = app_name
			@host_urls = Hash.new
			@actions = Hash.new
		end

		def add_host_url(host_alias, host_url)
			@host_urls.update(host_alias => host_url)
		end

		def host_url(host_alias)
			return @host_urls[host_alias] if @host_urls.has_key?(host_alias)
		end

		def create
			puts "create #{@app_name}"
		end

		def add_action(http_method, path, headers, requests)
			@actions.update(action_name(http_method, path) => Action.new(http_method, path, headers, requests))
		end

		def run_action(host_alias, http_method, path)
			action_name = action_name(http_method, path)
			action = @actions[action_name]
			p "run #{action} of #{action_name} by specific host #{host_url(host_alias)}"
		end

		private
		  def action_name(http_method, path)
		  	"#{path.gsub(/[\/\\\s]/, '')}_#{http_method}"
		  end

	end

	# HostUrl, included by a project
	class HostUrl

		def initialize(host_alias, host_url)
			@host_alias = host_alias
			@host_url = host_url
		end

	end

	# Action, included by a project
	class Action

		def initialize(http_method, path, headers=nil, requests=nil)
			@method = http_method
			@path = path
			@headers = headers
			@requests = requests
		end

	end

end

project = RemoteDataCli::Project.new("MyApp")
project.create

project.add_host_url("product_url", "http://www.xyz.com")
project.add_host_url("qa_url", "http://qa.xyz.com")

project.add_action(:post, "/events", 
	{"Content-Type": "application/json; charset=utf-8", 
		"other_header": "App"}, {'app'=>'MyApp'})

project.run_action("qa_url", :post, "/events")
