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
	#aDatabasa = Firebase.Database.get_database_reference("sandbox", {})
	var tobePush = {
		"fields":{
			"Auza":{"stringValue":"aaaaaaaaaaaw"}
		},
	}
	aDatabasa.push(tobePush)
	pass # Replace with function body.


func _on_FireBaseAuth_loggedInAuthed(theAuth):
	print("Amlogedin")
	$MehLog.text = String(theAuth)
	saveToFile(theAuth)
	pass # Replace with function body.


func _on_FireBaseAuth_loggedFaile(code,message):
	$MehLog.text = "Oh no faile code " + String(code) + "\n\nMessage:\n" + String(message)
	pass # Replace with function body.


func _on_FireBaseAuth_userDataGet(userData):
	print_debug("USER DATA GET")
	saveRawNow(userData)
	pass # Replace with function body.


func _on_FireBaseAuth_userDataDictionary(userDataDictionary):
	print_debug("USER DICTIONARY DATA GET")
	saveUserData(userDataDictionary)
	pass # Replace with function body.


func _on_Button2_pressed():
	aDatabasa = Firebase.Database.get_database_reference("sandbox", {})
	pass # Replace with function body.
