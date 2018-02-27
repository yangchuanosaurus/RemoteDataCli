# Create new project
project = RemotedataCli::Project.new("App")
project.create

remotedatacli create app

# Add restful action
project.add_action(:post, "/events", headers = [], requests = {})
??? remotedatacli add action post "/events" headers=a=b

# Configure workflow of action
project.run_action("qa_login_url", :post, "/login")
		.response(cookies)
		.run_action("qa_url", :post, "events")

# Run action test
project.run_action("qa_url", :post, "/events")
remotedatacli run qa_url post /rest/events

# Run all tests
project.run_actions
remotedatacli run_all

# Deploy the project to remote server
# and schedule run tests
project.deploy("ssh://server_ip")
remotedatacli deploy

# Generate API documents
project.gen_api
remotedatacli gen api

# Generate Android Library
project.gen_lib
remotedatacli gen lib

# start local server for a proxy
project.create_proxy(default_ip: localhost, default_port = 8088).start
remotedatacli run_as_proxy localhost 8080

class Order
	security
	quantity
	limit_price
	all_or_none
	value
	bought_or_sold

	def buy
	end

	def sell
	end
end

newOrder.to.buy(100.shares.of('IBM')) {
	limitPrice 300
	allOrNOne true
	valueAs (qty, unitPrice -> qty * unitPrice - 500 )
}

Order.new.buy(100.shares.of('IBM')) {
	:limitPrice => 300, 
	:allOrNone => true, b
	valueAs { |qty, unitPrice| qty * unitPrice - 500 }
}