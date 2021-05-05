extends Control

var saveToDir = "user://DummyTest/Firebaseton/"
var saveToPath = saveToDir + "LoggedAuth.json"
var saveUserPath = saveToDir + "UserData.json"
var saveRawUser = saveToDir + "UserRaw.txt"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var aDatabasa
var aDokumente = {
	Ald = "a",
	an = "a",
	tand = "12.4a",
}
onready var aStoreg = Firebase.Storage
onready var FileAccessModed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#aDatabasa = Firebase.Database.get_database_reference("Sandbox", aDokumente)
	#aDatabasa = Firebase.Database.get_database_reference("sandbox",{})
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func saveToFile(theAuth):
	var jsonify = JSONBeautifier.beautify_json(to_json(theAuth))
	var jsonfile = File.new()
	var jsondir = Directory.new()
	if !jsondir.dir_exists(saveToDir):
		jsondir.make_dir_recursive(saveToDir)
	if jsonfile.open(saveToPath, File.WRITE) == OK:
		jsonfile.store_string(jsonify)
		jsonfile.close()
	pass

func saveUserData(userData):
	var jsonify = JSONBeautifier.beautify_json(to_json(userData))
	var jsonfile = File.new()
	var jsondir = Directory.new()
	if !jsondir.dir_exists(saveToDir):
		jsondir.make_dir_recursive(saveToDir)
	if jsonfile.open(saveUserPath, File.WRITE) == OK:
		jsonfile.store_string(jsonify)
		jsonfile.close()
	
	
	pass

func saveRawNow(userRaw):
	var rawFile = File.new()
	if rawFile.open(saveRawUser, File.WRITE) == OK:
		rawFile.store_string(userRaw.as_text())
		rawFile.close()
	pass

func _on_Button_pressed():
	# realtime database push data
	if Firebase.Auth.auth:
		#aDatabasa = Firebase.Database.get_database_reference("sandbox", {})
	#	var tobePush = {
	#		"fields":{
	#			"Auza":{"stringValue":"aaaaaaaaaaaw"}
	#		},
	#	}
		#var tobePush = { "first": "Jack", "last": "Sparrow" }
		#aDatabasa.push(tobePush)
		aDatabasa.push({"awag" : "awag", "yawg" : "way"})
	pass # Replace with function body.


func _on_FireBaseAuth_loggedInAuthed(theAuth):
	print("Amlogedin")
	aDatabasa = Firebase.Database.get_database_reference("sandbox", {})
	$MehLog.text = String(theAuth)
	#saveToFile(theAuth)
	pass # Replace with function body.


func _on_FireBaseAuth_loggedFaile(code,message):
	$MehLog.text = "Oh no faile code " + String(code) + "\n\nMessage:\n" + String(message)
	pass # Replace with function body.


func _on_FireBaseAuth_userDataGet(userData):
	print_debug("USER DATA GET")
	#saveRawNow(userData)
	pass # Replace with function body.


func _on_FireBaseAuth_userDataDictionary(userDataDictionary):
	print_debug("USER DICTIONARY DATA GET")
	saveUserData(userDataDictionary)
	pass # Replace with function body.


func _on_Button2_pressed():
	# realtime database connect
	aDatabasa = Firebase.Database.get_database_reference("sandbox", {})
	pass # Replace with function body.


func _on_Button3_pressed():
	# storage
	$SelectFileLoadingMode.popup_centered()
	pass # Replace with function body.


func _on_SelectFileLoadingMode_FileAccessModeSelected(Which):
	match(Which):
		-1:
			#canceled
			pass
		0:
			$FileDialog.access = FileDialog.ACCESS_RESOURCES
			pass
		1:
			$FileDialog.access = FileDialog.ACCESS_USERDATA
			pass
		2:
			$FileDialog.access = FileDialog.ACCESS_FILESYSTEM
			pass
	
	if Which != -1:
		$FileDialog.popup_centered()
		pass
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	#aStoreg.upload(path,".","Spinning-crocodillo-oliveEdit-windows10Emoji.png") # it seems it's incomplete I think? idk
	aStoreg.ref("Arok/Nar")
	pass # Replace with function body.

# https://firebasestorage.googleapis.com/v0/b/hexagon-engine.appspot.com/o/Spinning-crocodillo-oliveEdit-windows10Emoji.png?alt=media&token=fd446f96-1802-451d-bc6c-0410c737eba0
func _on_Button4_pressed():
	aStoreg.download(".","Spinning-crocodillo-oliveEdit-windows10Emoji.png")
	pass # Replace with function body.
