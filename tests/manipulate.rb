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
	"#{str[0].upcase}#{str[1..-1]}" if !str.nil?
end

def join_name(name, parent_name = nil)
	if !parent_name.nil?
		"#{upcase(parent_name)}#{upcase(name)}"
	else
		upcase(name)
	end
end

def model_name(name)
	"#{upcase(name)}.model"
end

def add_field(name, field, parent_name = nil)
	model_name = join_name(model_name(name), parent_name)
	@class_instances[model_name] = Array.new if @class_instances[model_name].nil?
	@class_instances[model_name] << field # todo should update if the item in model_name exits
	@class_instances[model_name] = @class_instances[model_name].uniq
end

def manipulate_hash(name, data_hash, parent_name = nil)
	#p "manipulate hash of #{name}.model"
	p_name = parent_name.nil? ? name : "#{upcase(parent_name)}#{upcase(name)}"
	data_hash.keys.each do |key|
		value = data_hash[key]
		puts "hash---name=#{name}, parent_name=#{parent_name}, pname=#{p_name}, key=#{key} => #{join_name(key, name)}"
		if value.is_a?(Hash)
			model_name = "#{name}"
			add_field(name, Field.new(key, model_name(join_name(key, p_name))), parent_name)
		elsif value.is_a?(Array)
			model_name = "#{name}#{upcase(key)}Item"
			add_field(name, FieldArray.new(key, join_name(model_name(model_name), parent_name)), parent_name)
		else
			add_field(name, Field.new(key, value.class), parent_name)
		end
	end

	data_hash.map do |key, value|
		if value.is_a?(Hash)
			#p "===#{key} #{p_name}"
			manipulate_hash(key, value, p_name)
		elsif value.is_a?(Array)
			model_name = "#{upcase(key)}Item"
			#puts "===key=#{key}, name=#{name}, #{join_name(model_name, p_name)}, pname=#{parent_name}"
			
			manipulate_array("#{model_name}", value, p_name)
		end
	end
end

def manipulate_array(name, data_array, parent_name)
	p_name = parent_name.nil? ? name : "#{upcase(parent_name)}"

	data_array.each do |value|
		
		if value.is_a?(Hash)
			manipulate_hash(name, value, p_name)
		elsif value.is_a?(Array)
			model_name = "#{upcase(name)}Item"
			puts "===value=#{value}, name=#{name}, parent_name=#{parent_name}, pname=#{p_name}"
			manipulate_array(name, value, join_name(name, p_name))
		else
			add_field(name, Field.new(model_name(value), "Array"))
		end

	end
end

def manipulate(name, data_json)
	if data_json.is_a?(Hash)
		manipulate_hash(upcase(name), data_json)
	elsif data_json.is_a?(Array)
		manipulate_array("#{upcase(name)}Item", data_json)
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

json_mix_2 = %Q{{
	"success": true,
	"results": {
		"getEvents": {
			"keyword": "5k",
			"events": [{
				"metaInterestNames": [],
				"assetTopics": [{
					"topicName": "Running",
					"topicTaxonomy": "Endurance/Running"
				}],
				"eventId": "E-01SH5K22",
				"regStatus": "reg-unavailable",
				"assetTypeId": "dfaa997a-d591-44ca-9fb7-bf4a4c8984f1",
				"city": "Reeds Spring",
				"assetId": "4e9c83fc-15f7-42d6-8df8-5a105b2b0968",
				"latitude": "36.731504",
				"eventName": "5K - 5k",
				"state": "MO",
				"eventDate": "09/01/2018",
				"longitude": "-93.37734"
			}, {
				"metaInterestNames": [],
				"assetTopics": [{
					"topicName": "Running",
					"topicTaxonomy": "Endurance/Running"
				}],
				"eventId": "E-01SYFWZ0",
				"regStatus": "reg-unavailable",
				"assetTypeId": "dfaa997a-d591-44ca-9fb7-bf4a4c8984f1",
				"city": "Salina",
				"assetId": "c8295c6b-b88c-4f2a-b411-967e07b73cd9",
				"latitude": "38.884986",
				"eventName": "Running-5K - Running/5K",
				"state": "KS",
				"eventDate": "04/21/2018",
				"longitude": "-97.593804"
			}, {
				"metaInterestNames": [],
				"assetTopics": [{
					"topicName": "Running",
					"topicTaxonomy": "Endurance/Running"
				}],
				"eventId": "E-01QLC7FB",
				"regStatus": "reg-unavailable",
				"assetTypeId": "dfaa997a-d591-44ca-9fb7-bf4a4c8984f1",
				"city": "Wichita",
				"assetId": "43a392bd-058c-40e0-8707-013346136003",
				"latitude": "37.682003",
				"eventName": "5K - 5K",
				"state": "KS",
				"eventDate": "05/06/2018",
				"longitude": "-97.34063"
			}, {
				"metaInterestNames": [],
				"assetTopics": [{
					"topicName": "Running",
					"topicTaxonomy": "Endurance/Running"
				}],
				"eventId": "E-01QLC7FB",
				"regStatus": "reg-unavailable",
				"assetTypeId": "dfaa997a-d591-44ca-9fb7-bf4a4c8984f1",
				"city": "Wichita",
				"assetId": "8f57a873-3ed2-4961-bee4-da82d3a6c449",
				"latitude": "37.682003",
				"eventName": "5K - 5K",
				"state": "KS",
				"eventDate": "05/06/2018",
				"longitude": "-97.34063"
			}, {
				"metaInterestNames": [],
				"assetTopics": [{
					"topicName": "Running",
					"topicTaxonomy": "Endurance/Running"
				}],
				"eventId": "E-01QJF662",
				"regStatus": "reg-unavailable",
				"assetTypeId": "dfaa997a-d591-44ca-9fb7-bf4a4c8984f1",
				"city": "Wichita",
				"assetId": "0dac172a-e825-45f8-94b4-8cb6824e1ada",
				"latitude": "37.682003",
				"eventName": "5K - 5K",
				"state": "KS",
				"eventDate": "10/14/2018",
				"longitude": "-97.34063"
			}],
			"eventNum": 5
		}
	}
}	
}

resp_body = JSON.parse(json_mix)

manipulate('root', resp_body)

p "----------------"
@class_instances.map do |key, value|
	puts "===#{key}->\n\t#{value}"
end
