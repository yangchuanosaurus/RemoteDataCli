require 'json'

def manipulate_hash(data_hash)
	p "manipulate hash"
	data_hash.map do |key, value|
		puts "#{key} : #{value.class}"
		if value.is_a?(Hash)
			p "#{key} mapping"
			manipulate_hash(value)
		elsif value.is_a?(Array)
			manipulate_array(value)
		end
	end
end

def manipulate_array(data_array)
	p "manipulate array"
	data_array.each do |value|
		
		if value.is_a?(Hash)
			manipulate_hash(value)
		elsif value.is_a?(Array)
			manipulate_array(value)
		else
			p "directly mapping as #{value} : #{value.class}"
		end
		
	end
end

def manipulate(data_json)
	if data_json.is_a?(Hash)
		manipulate_hash(data_json)
	elsif data_json.is_a?(Array)
		manipulate_array(data_json)
	end
end

json = %Q{{
	"results": {
		"a": 1, 
		"b": "b", 
		"c": "c"
	}, 
	"success": true
}}

p json.class

resp_body = JSON.parse(json)
manipulate(resp_body)
