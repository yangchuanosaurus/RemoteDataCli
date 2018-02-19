# Create new project
project = Remotedatacli::Project.new("App")

# Set host url
project.addHostUrl("product_url", "http://www.xyz.com")
project.addHostUrl("qa_url", "http://qa.xyz.com")

# Add restful action
project.use_url("qa_url").addAction(:post, "/events", headers = [], requests = {})

# Run action test
project.run_action("qa_url", :post, "/events")

# Run all tests
project.run_actions

# Schedule run tests
project.run_actions_with_schedule("60mins")

# Generate API documents
project.gen_api

# Generate Android Library
project.gen_lib
