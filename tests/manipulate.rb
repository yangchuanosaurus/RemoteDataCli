require 'json'

def manipulate_hash(name, data_hash)
	#p "manipulate hash of #{name}.model"
	data_hash.keys.each do |key|
		value = data_hash[key]
		if value.is_a?(Hash)
			puts "#{name}.model #{key} : #{key}.model"
		elsif value.is_a?(Array)
			puts "#{name}.model #{key} : #{key}Array<#{key}Item>.model"
		else
			puts "#{name}.model #{key} : #{value.class}"
		end
	end

	data_hash.map do |key, value|
		if value.is_a?(Hash)
			manipulate_hash(key, value)
		elsif value.is_a?(Array)
			manipulate_array("#{key}Item", value)
		end
	end
end

def manipulate_array(name, data_array)
	#p "manipulate array of #{name}.model"
	data_array.each do |value|
		
		if value.is_a?(Hash)
			manipulate_hash(name, value)
		elsif value.is_a?(Array)
			manipulate_array(name, value)
		else
			p "#{name}.model : #{value.class}"
		end

	end
end

def manipulate(name, data_json)
	p "manipulate #{name}.model"
	if data_json.is_a?(Hash)
		manipulate_hash(name, data_json)
	elsif data_json.is_a?(Array)
		manipulate_array("#{name}Item", data_json)
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

json_array = %Q{{
		"results": [
			{
				"a": 1, 
				"b": true, 
				"c": 1.0, 
				"d": "d"
			}
		]
	}
}

resp_body = JSON.parse(json_array)

manipulate('root', resp_body)
