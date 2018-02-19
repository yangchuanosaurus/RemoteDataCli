# Create new project
project = RemotedataCli::Project.new("App")
project.create

# Set host url
project.add_host_url("product_url", "http://www.xyz.com")
project.add_host_url("qa_url", "http://qa.xyz.com")

# Add restful action
project.add_action(:post, "/events", headers = [], requests = {})

# Run action test
project.run_action("qa_url", :post, "/events")

# Run all tests
project.run_actions

# Deploy the project to remote server
# and schedule run tests
project.deploy("ssh://server_ip")

# Generate API documents
project.gen_api

# Generate Android Library
project.gen_lib

# start local server for a proxy
project.create_proxy(default_ip: localhost, default_port = 8088).start