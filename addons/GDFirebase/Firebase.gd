extends Node

const ENVIRONMENT_VARIABLES : String = "environment_variables/"
onready var Auth = HTTPRequest.new()
onready var Firestore = Node.new()
onready var Database = Node.new()

# Configuration used by all files in this project
# These values can be found in your Firebase Project
# See the README on Github for how to access

# FATAL!!! DO NOT LOAD CONFIG HARD CODE WAY!!! USE SEPARATE FILE!!!
# IF CODE SPREAD WILD BECAUSE FORGOT IGNORE, YOUR FIREBASE COULD BE
# HACKED!!!

# read https://github.com/WolfgangSenff/GodotFirebase/issues/27

# uh udpdate. he said it's public. things to concern is the security rule.

# DO NOT USE THIS NOW!!! WAIT UNTIL FIX COMES
#var config = {  
#	"apiKey": ProjectSettings.get_setting("Google/FireBase/ApiKey"),
#	"authDomain": ProjectSettings.get_setting("Google/FireBase/AuthDomain"),
#	"databaseURL": ProjectSettings.get_setting("Google/FireBase/DatabaseUrl"),
#	"projectId": ProjectSettings.get_setting("Google/FireBase/ProjectId"),
#	"storageBucket": ProjectSettings.get_setting("Google/FireBase/StorageBucket"),
#	"messagingSenderId": ProjectSettings.get_setting("Google/FireBase/MessagingSenderId"),
#	"appId": ProjectSettings.get_setting("Google/FireBase/AppId"),
#	"measurementId": ProjectSettings.get_setting("Google/FireBase/MeasurementId"),
#	}

var config = {  
	"apiKey": "AIzaSyDtTuVW5h-ehAj9E0v-hL64Lpnva395ZL8",
	"authDomain": "hexagon-engine.firebaseapp.com",
	"databaseURL": "https://hexagon-engine.firebaseio.com",
	"projectId": "hexagon-engine",
	"storageBucket": "hexagon-engine.appspot.com",
	"messagingSenderId": "1058646999710",
	"appId": "1:1058646999710:web:61990d2eeca7053c64718f",
	"measurementId": "G-9K4LW2G9JW",
	}

func load_config():
	if ProjectSettings.has_setting(ENVIRONMENT_VARIABLES+"apiKey"):
		for key in config.keys():
			config[key] = ProjectSettings.get_setting(ENVIRONMENT_VARIABLES+key)
	else:
		printerr("No configuration settings found, add them in override.cfg file.")

func _ready():
	load_config()
	Auth.set_script(preload("res://addons/GDFirebase/FirebaseAuth.gd"))
	Firestore.set_script(preload("res://addons/GDFirebase/FirebaseFirestore.gd"))
	Database.set_script(preload("res://addons/GDFirebase/FirebaseDatabase.gd"))
	Auth.set_config(config)
	Firestore.set_config(config)
	Database.set_config(config)
	add_child(Auth)
	add_child(Firestore)
	add_child(Database)
	Auth.connect("login_succeeded", Database, "_on_FirebaseAuth_login_succeeded")
	Auth.connect("login_succeeded", Firestore, "_on_FirebaseAuth_login_succeeded")
