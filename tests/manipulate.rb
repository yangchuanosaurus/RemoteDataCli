require 'json'

@class_instances = Hash.new

class Field
	attr_reader :name, :type

	def initialize(name, type)
		@name = name
		@type = type
	end

	def to_s
		inspect
	end

	def ==(other_item)
		@name == other_item.name && @type == other_item.type
	end

	def hash
		self.name.hash ^ self.type.hash
	end

	def eql?(other_item)
		@name == other_item.name && @type == other_item.type
	end
end

class FieldArray
	attr_reader :name, :type, :item_type
	
	def initialize(name, item_type)
		@name = name
		@type = "Array"
		@item_type = item_type
	end

	def to_s
		inspect
	end

	def ==(other_item)
		@name == other_item.name && @item_type == other_item.item_type
	end

	def hash
		self.name.hash ^ self.item_type.hash
	end

	def eql?(other_item)
		@name == other_item.name && @item_type == other_item.item_type
	end
end

def upcase(str)
	"#{str[0].upcase}#{str[1..-1]}"
end

def model_name(name)
	"#{upcase(name)}.model"
end

def add_field(name, field)
	model_name = model_name(name)
	@class_instances[model_name] = Array.new if @class_instances[model_name].nil?
	@class_instances[model_name] << field # todo should update if the item in model_name exits
	@class_instances[model_name] = @class_instances[model_name].uniq
end

def manipulate_hash(name, data_hash)
	#p "manipulate hash of #{name}.model"
	data_hash.keys.each do |key|
		value = data_hash[key]
		if value.is_a?(Hash)
			add_field(name, Field.new(key, model_name(key)))
		elsif value.is_a?(Array)
			add_field(name, FieldArray.new(key, "#{model_name(key + "Item")}"))
		else
			add_field(name, Field.new(key, value.class))
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
	data_array.each do |value|
		
		if value.is_a?(Hash)
			manipulate_hash(name, value)
		elsif value.is_a?(Array)
			manipulate_array(name, value)
		else
			add_field(name, Field.new(model_name(value), "Array"))
		end

	end
end

def manipulate(name, data_json)
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
				"c": 1.0
			}, 
			{
				"a": 1, 
				"b": true, 
				"c": 1.0, 
				"d": "d"
			}, 
			{
				"e": "ename"
			}
		]
	}
}

json_mix = %Q{
	{
	"results": {
		"linkedAppInfo": [{
			"appShortDesc": "The ACTIVE app gives you a fast and easy way to search, save, share and register for activities right from your phone.",
			"appName": "ACTIVE",
			"appID": "com.active.fnd.mobile",
			"largeIconURL": "/images/icons/android_activeDotCom_512x512.png",
			"appLongDesc": null,
			"smallIconURL": "/images/icons/android_activeDotCom_72x72.png",
			"appInstallURL": null
		}, {
			"appShortDesc": "This is the OFFICIAL CoolRunning Couch to 5K® beginner training plan, brought to you by Active.com!",
			"appName": "Couch to 5K®",
			"appID": "com.active.aps.c25k",
			"largeIconURL": "/images/icons/android_c25k_512x512.png",
			"appLongDesc": null,
			"smallIconURL": "/images/icons/android_c25k_72x72.png",
			"appInstallURL": null
		}, {
			"appShortDesc": "Continue your training for a 10K with the same trainers from our award winning Couch to 5K® app.",
			"appName": "5K to 10K",
			"appID": "com.active.aps.tenk",
			"largeIconURL": "/images/icons/android_5kto10k_512x512.png",
			"appLongDesc": null,
			"smallIconURL": "/images/icons/android_5kto10k_72x72.png",
			"appInstallURL": null
		}, {
			"appShortDesc": "Meet Mobile, powered by ACTIVE.com and HY-TEK Sports Software gives swimmers, coaches and fans access to real-time meet results.",
			"appName": "Meet Mobile",
			"appID": "com.active.aps.meetmobile",
			"largeIconURL": "/images/icons/android_meMo_512x512.png",
			"appLongDesc": null,
			"smallIconURL": "/images/icons/android_meMo_72x72.png",
			"appInstallURL": null
		}, {
			"appShortDesc": "The solution to your kid's boredom now fits in the palm of your hand! Parenting just got a little easier with the largest kids activity app on the planet.",
			"appName": "ACTIVEKids",
			"appID": "om.active.fnd.kids",
			"largeIconURL": "/images/icons/android_ActiveKids_512x512.png",
			"appLongDesc": null,
			"smallIconURL": "/images/icons/android_ActiveKids_72x72.png",
			"appInstallURL": null
		}]
	}
}
}

resp_body = JSON.parse(json_mix)

manipulate('root', resp_body)

p "----------------"
@class_instances.map do |key, value|
	puts "===#{key}->\n\t#{value}"
end
