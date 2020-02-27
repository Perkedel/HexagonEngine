extends Object

func parse_header(request):
	var requestLine = {}
	var lines = request.split("\r\n", true)
	
	#parse first request line 
	var line_split = lines[0].split(" ",true)
	
	
	
	requestLine["verb"] = line_split[0]
	
	if(line_split.size() == 1 or requestLine["verb"]=="HTTP/1.1"):
		return -2
		
	requestLine["url"] = line_split[1]
	
	requestLine["version"] = line_split[2]
	requestLine["params"] = {}
	
	if(requestLine["url"].find("?", 0)>0):
		var query = requestLine["url"].split("?", true)
		if( query.size()>1 ):
			requestLine["url"] = query[0]
			requestLine["params"] = parse_query_string(query[1])
	
	lines.set(0, "")
	
	#parse header values
	for line in lines:
		if line != "":
			var pair = line.split(": ", true)
			requestLine[pair[0].to_lower()] = pair[1]

	return requestLine


func decode(string: String):
	var new_string = string.percent_decode()
	#new_string = new_string.substr(0,new_string.length()-1)
	return new_string

func parse_query_string(query):
	var params_array = query.split("&", true)
	#to dict
	var params_map = {}
	for param in params_array:
		if param != "":
			# TODO keys_to_lower??
			var key_value = param.split("=", true)
			params_map[decode(key_value[0])] = decode(key_value[1])
	return params_map

var __httpClient__ = HTTPClient.new()
func query_string_from_dict(dict):
	return __httpClient__.query_string_from_dict(dict)

func build_header(code, header_dict):
	var header = "HTTP/1.1 " + str(code) + "\r\n"
	
	for key in header_dict:
		header += key + ": "
		if(typeof(header_dict[key]) == TYPE_ARRAY):
			
			var counter = 0
			for field in header_dict[key]:
				
				counter += 1
				if(counter < header_dict[key].size()):
					header += field + "; "
				else:
					header += field
		else:
			header += header_dict[key]
		header += "\r\n"
	
	return header
	
func response(code,header_dict,body,connection):
	var raw_body = body.to_utf8()
	header_dict["content-length"] = str(raw_body.size())
	var header = build_header(code,header_dict) + "\r\n"
	connection.put_data(header.to_utf8() + raw_body)
	
	
func get_header(connection):
	var request = ""
	while(request.substr(request.length()-4, request.length()) != "\r\n\r\n"):
		#check someone disconnected
		if(connection != null && !connection.is_connected_to_host()):
			break
		#Waiting until data incoming
		request += connection.get_data(1)[1].get_string_from_utf8()
	var og_header = request
	request = parse_header(request)
	if(typeof(request) != TYPE_DICTIONARY):
		return null
	request.original_header = og_header
	return request