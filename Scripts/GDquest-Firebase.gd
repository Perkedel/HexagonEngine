extends Node

# https://github.com/GDQuest/godot-demos/blob/master/2019/05-21-firebase-firestore/end/static/Firebase.gd
# https://firebase.google.com/docs/reference/rest/auth
# Help. https://github.com/WolfgangSenff/GodotFirebase has problem with Firestore
# https://softauthor.com/firestore-security-rules/
# 

@onready var API_KEY :String = ProjectSettings.get_setting("Google/Firebase/ApiKey")
@onready var AUTH_DOMAIN:String = ProjectSettings.get_setting("Google/Firebase/AutoDomain")
@onready var DATABASE_URL:String = ProjectSettings.get_setting("Google/Firebase/DatabaseUrl")
@onready var PROJECT_ID :String = ProjectSettings.get_setting("Google/Firebase/ProjectId")
@onready var STORAGE_BUCKET:String = ProjectSettings.get_setting("Google/Firebase/StorageBucket")
@onready var MESSAGING_SENDER_ID:String = ProjectSettings.get_setting("Google/Firebase/MessagingSenderId")
@onready var APP_ID:String = ProjectSettings.get_setting("Google/Firebase/AppId")
@onready var MEASUREMENT_ID:String = ProjectSettings.get_setting("Google/Firebase/MeasurementId")

@onready var REGISTER_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=%s" % API_KEY
@onready var LOGIN_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=%s" % API_KEY
@onready var FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
@onready var GET_USER_DATA_URL := "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=%s" % API_KEY

@onready var REFRESH_REQUEST_URL := "https://securetoken.googleapis.com/v1/token?key=%s" % API_KEY

var user_info := {}

func _ready():
	
	pass

func get_full_user_data(FirebaseToken,http: HTTPRequest) -> Dictionary:
	var body := {
		"idToken": FirebaseToken
	}
	http.request(GET_USER_DATA_URL, [], HTTPClient.METHOD_POST, JSON.new().stringify(body))
	var result := await http.request_completed as Dictionary
	if result[1] == 200:
		return result
	else:
		return {}
	pass

func _get_user_info(result: Array) -> Dictionary:
	var test_json_conv = JSON.new()
	test_json_conv.parse(result[3].get_string_from_ascii()).result as Dictionary
	var result_body := test_json_conv.get_data()
	return {
		"token": result_body.idToken,
		"id": result_body.localId
	}


func _get_request_headers() -> PackedStringArray:
	return PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])


func register(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
	}
	http.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, JSON.new().stringify(body))
	var result := await http.request_completed as Array
	if result[1] == 200:
		user_info = _get_user_info(result)


func login(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	http.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, JSON.new().stringify(body))
	var result := await http.request_completed as Array
	if result[1] == 200:
		user_info = _get_user_info(result)

func refreshRequest():
	var body := {
		"grant_type":"refresh_token",
		"refresh_token":""
		}
	
	pass


func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := JSON.new().stringify(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)


func get_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)


func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := JSON.new().stringify(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)

func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)
