# RemoteDataCli
Command line tools for support AndroidRemoteData

get project configure from project.json
get action configure from action_method.json
run specific action
run all actions

## Create a RemoteData project
```
remotedatacli new app
```
Now, configure the project.json
```
{
	"name": "app", 
	
	"version": 1, 
	"author": "Albert Zhao",
	"email": "355592261@qq.com",
	"organization": "Mobile, ZERO ORG", 
	"message": "App integrated with RemoteData",

	"hosts": {
		"dev": "http://dev.host.com", 
		"qa": "https://qa.host.com"
	}, 
	
	"template-center": [
		"https://templates.cli.org"
	], 
	"dependencies": {
		"remote-data-android": 1
	}
}
```

## Create a restful action
```
remotedatacli add_action post /rest/events
```

## Run a special action
```
remotedatacli run_action qa post /rest/events
```

## Run all actions
```
remotedatacli run qa
```
