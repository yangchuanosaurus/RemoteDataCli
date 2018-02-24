require 'rest-client'

module RemoteDataCli
	module Api
		class ClientApi
			
			def initialize
				RestClient.log = 'stdout'
			end

			def get(url, path, headers, params)
				data = { :method => :get, :url => url << path }
				data[:headers] = {}
				
				headers.map { |n, v| data[:headers][n] = v } if !headers.nil?
				data[:headers][:params] = params if !params.nil?
				
				RestClient::Request.execute( data )
			end

			def post()
			end

		end
	end
end