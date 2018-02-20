# Create new project
project = RemotedataCli::Project.new("App")
project.create

remotedatacli create app

# Set host url
project.add_host_url("product_url", "http://www.xyz.com")
project.add_host_url("qa_url", "http://qa.xyz.com")

remotedatacli add host product_url=http://www.xyz.com qa_url=http://qa.xyz.com

# Add restful action
project.add_action(:post, "/events", headers = [], requests = {})
??? remotedatacli add action post "/events" headers=a=b

# Run action test
project.run_action("qa_url", :post, "/events")
remotedatacli run qa_url post events

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