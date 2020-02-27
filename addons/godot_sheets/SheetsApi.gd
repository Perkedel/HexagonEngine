tool
extends Node

var __dirname = get_script().resource_path.get_base_dir()
var enabled = false

signal auth_code_granted(code)
signal access_token_granted(token)
signal has_access(token)
signal access_revoked()
signal json_handled(json)
signal log_msg(message)
signal sheet_loaded(filename)

var config_path = "user://godot_sheets.cfg"
var config = ConfigFile.new()

var auth_code = null
var access_token = null
var access_token_expiration = INF
var server = TCP_Server.new()

var rest = preload("./rest.gd").new()
var sheets = []

var client_id = "387934792805-ve2en17aat8rpq35rrr73toas911jukd.apps.googleusercontent.com"
var client_secret = "c1m5eR0Yicb4iOg770GY1Syr"
var redirect_uri = "http://localhost:8000"

var code_verifier:String

var cache = {}
var html_file = File.new()

func generate_code_verifier() -> String:
	var arr = PoolByteArray()
	randomize()
	var possible = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~".to_ascii())
	possible.shuffle()
	for i in range(43 + randi() % 85):
		arr.append(possible[randi() % possible.size()])
	return arr.get_string_from_ascii()

func request_auth_code():
	if(auth_code):
		emit_signal("auth_code_granted",auth_code)
		return
	code_verifier = generate_code_verifier()
	var query = rest.query_string_from_dict({
		"client_id":client_id,
		"response_type":"code",
		"scope":"https://www.googleapis.com/auth/spreadsheets.readonly https://www.googleapis.com/auth/drive.metadata.readonly",
		"redirect_uri":redirect_uri,
		"code_challenge_method":"plain",
		"code_challenge":code_verifier,
		"prompt":"consent"
	})
	set_process(true)
	OS.shell_open("https://accounts.google.com/o/oauth2/v2/auth?" + query)
	emit_signal("log_msg","Auth Code Requested")

func request_access_token(auth_code):

	var headers=["Content-Type: application/x-www-form-urlencoded"]
	var query = rest.query_string_from_dict({
		"code":auth_code,
		"client_id":client_id,
		"client_secret":client_secret,
		"redirect_uri":redirect_uri,
		"grant_type":"authorization_code",
		"code_verifier":code_verifier
	})

	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed",self,"handle_access_token",[http],CONNECT_ONESHOT)
	http.request("https://www.googleapis.com/oauth2/v4/token",headers,true,HTTPClient.METHOD_POST,query)
	emit_signal("log_msg","Access Token Requested")

func request_refresh_token():
	var headers=["Content-Type: application/x-www-form-urlencoded"]
	var query = rest.query_string_from_dict({
		"client_id":client_id,
		"client_secret":client_secret,
		"grant_type":"refresh_token",
		"refresh_token":config.get_value("google.api","refresh_token")
	})

	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed",self,"handle_access_token",[http],CONNECT_ONESHOT)
	http.request("https://www.googleapis.com/oauth2/v4/token",headers,true,HTTPClient.METHOD_POST,query)
	emit_signal("log_msg","Refresh Token Requested")

func revoke_access():
	var refresh_token = config.get_value("google.api","refresh_token", false)

	config.set_value("google.api","refresh_token",null)
	config.set_value("google.api","auth_code",null)
	config.save(config_path)

	var token = access_token
	if(refresh_token):
		token = refresh_token
	access_token = null
	auth_code = null
	if(token):
		var headers=["Content-Type: application/x-www-form-urlencoded"]
		var query = rest.query_string_from_dict({
			"token":token
		})

		var http = HTTPRequest.new()
		add_child(http)
		http.request("https://accounts.google.com/o/oauth2/revoke?"+query,headers,true,HTTPClient.METHOD_GET,"")
	handle_access_revoked()


func validate_token():
	if(OS.get_ticks_msec() >= access_token_expiration):
		request_refresh_token()
		yield(self,"has_access")

func handle_access_revoked():
	emit_signal("access_revoked")
	emit_signal("log_msg","Token Revoked")

func handle_auth_code(code):
	set_process(false)
	server.stop()
	emit_signal("log_msg","Auth Code Granted")
	config.set_value("google.api","auth_code",code)
	config.save(config_path)
	if(config.has_section_key("google.api","refresh_token")):
		request_refresh_token()
	else:
		request_access_token(code)

func handle_access_token(result,response_code,header,body,http):
	var data = JSON.parse(body.get_string_from_utf8()).result

	if(data):
		if(data.has("error")):

			emit_signal("log_msg",data.error_description)
			revoke_access()
			return

		if(data.has("access_token")):
			access_token = data.access_token
			access_token_expiration = data.expires_in*1000 + OS.get_ticks_msec()

			config.set_value("google.api","refresh_token",access_token)
			config.save(config_path)

			emit_signal("log_msg","Token Granted")
			emit_signal("has_access",access_token)
		else:
			access_token = null
			access_token_expiration = false

	http.queue_free()


func get_sheet(sheet_id : String):
	validate_token()
	var headers=["Authorization: Bearer "+str(access_token)]
	var query = rest.query_string_from_dict({
		"includeGridData":false
	})

	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed",self,"handle_json",[http],CONNECT_ONESHOT)
	http.request("https://sheets.googleapis.com/v4/spreadsheets/"+sheet_id+"?"+query,headers,true,HTTPClient.METHOD_GET,"")

func get_sheet_values(sheet_id: String, cell_ranges: Array):
	validate_token()
	var headers=["Authorization: Bearer "+str(access_token)]
	var query = "?"+rest.query_string_from_dict({
		"ranges":cell_ranges,
		"majorDimension":"ROWS"
	})
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed",self,"handle_json",[http],CONNECT_ONESHOT)
	http.request("https://sheets.googleapis.com/v4/spreadsheets/"+sheet_id+"/values:batchGet"+query,headers,true,HTTPClient.METHOD_GET,"")

func handle_json(result,response_code,header,body,http,cache_key = false):

	var data = JSON.parse(body.get_string_from_utf8()).result

	emit_signal("log_msg","Data Recieved: "+str(body.size())+"bytes")
	#emit_signal("log_msg",JSON.print(data,"\t"))
	if(data.has("error")):
		#print(data)
		emit_signal("log_msg",data.error.message)
	elif(bool(cache_key) != false):
		cache[cache_key] = data
	http.queue_free()
	emit_signal("json_handled",data)


func get_drive_sheets():
	emit_signal("log_msg","Getting sheets from google drive")
	var cache_key = "drive_sheets"
	if(cache.has(cache_key)):
		call_deferred("emit_signal","json_handled",cache[cache_key])
		return
	validate_token()
	var headers=["Authorization: Bearer "+str(access_token)]
	var query = rest.query_string_from_dict({
		"q":"mimeType = 'application/vnd.google-apps.spreadsheet'",
		"spaces":"drive",
		"orderBy":"title"
	})

	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed",self,"handle_json",[http,cache_key],CONNECT_ONESHOT)
	http.request("https://www.googleapis.com/drive/v2/files?"+query,headers,true,HTTPClient.METHOD_GET,"")


func get_all_sheet_values(sheet_id: String):
	emit_signal("log_msg","Getting Sheet with id: "+sheet_id)
	get_sheet(sheet_id)
	var sheet = yield(self,"json_handled")
	var data = {}
	var cell_range = []
	if(sheet.has("error")):
		return

	for s in sheet.sheets:
		var title:String = s.properties.title
		if(s.properties.has("hidden") || title.begins_with("_")):
			continue
		data[title.replace(" ","_")] = {}
		cell_range.append(title)

	get_sheet_values(sheet_id,cell_range)
	var sheets_data = yield(self,"json_handled")
	if(sheets_data.has("error")):
		return

	for s in range(sheets_data.valueRanges.size()):
		var addition_method = "ROWS"
		var sheet_data = sheets_data.valueRanges[s]
		var title = cell_range[s].replace(" ","_")
		var field_names = null
		
		if(sheet_data.has("values") == false):
			#empty sheet
			continue
		for row in sheet_data.values:
			if(row.size() == 0):
				#empty line
				continue
			var command = row[0].split(":")
			if(command[0] == "FIELD_NAMES"):
				row.pop_front()
				if(command.size() == 2 and (command[1] == "ROWS" or command[1] == "COLS")):
					addition_method = command[1]
				else:
					addition_method == "ROWS"
				
				if(addition_method == "ROWS"):
					if(row.size() > 0):
						field_names = PoolStringArray(row)
					else:
						field_names = null
				else:
					field_names = PoolStringArray(row)
					for i in range(row.size()):
						if(data[title].has(row[i]) == false):
							data[title][row[i]] = {}
					
			elif(command[0] == "IGNORE"):
				continue
			elif(command[0] == "SUBSHEET"):
				title = command[1]
				if(data.has(title) == false):
					data[title] = {}
			else:
				if(addition_method == "ROWS"):
					if(field_names == null):
						var key_name = row.pop_front()
						if(data[title].has(key_name) == false):
							data[title][key_name] = []
						for i in range(row.size()):
							if(row[i] == "TRUE" || row[i] == "FALSE"):
								row[i] = row[i].to_lower()
							data[title][key_name].append(row[i])
					else:
						if(data[title].has(row[0]) == false):
							data[title][row[0]] = {}
						for i in range(1,row.size()):
							if(row[i] == "TRUE" || row[i] == "FALSE"):
								row[i] = row[i].to_lower()
							data[title][row[0]][field_names[i-1]] = row[i]
				else:
					for i in range(1,row.size()):
						if(row[i] == "TRUE" || row[i] == "FALSE"):
							row[i] = row[i].to_lower()
						data[title][field_names[i-1]][row[0]] = row[i]
		


	var filename = __dirname+"/singletons/"+sheet.properties.title.replace(" ","_")+".tscn"
	save_node_from_dict(filename,data)

	sheets = [[sheet.properties.title,sheet_id]]
	config.set_value("user_data","sheets",sheets)
	config.save(config_path)
	#emit_signal("log_msg", JSON.print(data,"\t"))
	emit_signal("log_msg","File saved to: "+filename)
	emit_signal("sheet_loaded",filename)
	return data

func save_node_from_dict(filename, dict):
	var node = Node.new()
	var script = GDScript.new()
	script.source_code="extends Node\r\n"
	for i in dict:
		script.source_code += "export var "+i+":Dictionary\r\n"
	script.reload()
	node.set_script(script)

	for i in dict:
		node.set(i,dict[i])

	var packedScene = PackedScene.new()
	packedScene.pack(node)
	var dir = Directory.new()
	dir.make_dir_recursive(filename.get_base_dir())
	ResourceSaver.save(filename,packedScene)

func _ready():
	if(enabled == false):
		return
	set_process(false)
	server.listen(8000)
	connect("auth_code_granted",self,"handle_auth_code")

	#it's dumb that I can't get the relative path of this script

	if(html_file.open(__dirname+"/success.html",File.READ) != OK):
		print("failed to load success.html")

	if(config.load(config_path) == OK):
		# save what sheets we've selected
		if(config.has_section_key("user_data","sheets") == false):
			config.set_value("user_data","sheets",sheets)
			config.save(config_path)
		else:
			sheets = config.get_value("user_data","sheets",[])

		if(config.has_section_key("google.api","auth_code")):
			auth_code = config.get_value("google.api","auth_code")
			emit_signal("auth_code_granted",auth_code)
	print("Godot Sheets Api Ready")


func _process(delta):
	if(server.is_connection_available()):
		var connection = server.take_connection()
		var request = rest.get_header(connection)
		
		
		if(request and request.params.has("code")):
			auth_code = request.params["code"]
			rest.response(200,{
				"content-type":"text/html; charset=utf-8"
			},html_file.get_as_text(),connection)

			connection = null

			call_deferred("emit_signal","auth_code_granted",auth_code)
#		else:
#			print(request.params)
#			print(request.original_header)
