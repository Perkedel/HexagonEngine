extends HBoxContainer
# https://github.com/WolfgangSenff/GodotFirebase

onready var Authing = $AUTHING
onready var Authed = $AUTHED
onready var PlsWaiter = $PLSWAIT
onready var userButton = Authed.get_node("USERbutton")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var authedMe
var firebaseReferencer
var UserNameText
var PasswordText ## Do not save this variable on disk unencrypted!!!

var HourglassRotateDegree:float = 0
onready var TimePiece = $PLSWAIT/HourGlassContainer/GravityHourGlass
onready var TimerFrameHourglass = $PLSWAIT/HourglassFramePerSecond

signal loggedInAuthed(theAuth)
signal loggedFaile(code, message)
signal userDataGet(userData)
signal userDataDictionary(userDataDictionary)

var userDictionaryData = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_LoginSuccess")
	Firebase.Auth.connect("login_failed", self, "_on_FirebaseAuth_LoginFail")
	Firebase.Auth.connect("userdata_received", self, "_on_FirebaseAuth_GetUserData")
	pass # Replace with function body.

func RotateHourglass():
	HourglassRotateDegree += 2
	if HourglassRotateDegree >= 360:
		HourglassRotateDegree = HourglassRotateDegree - 360
		pass    
	TimePiece.set_rotation_degrees(HourglassRotateDegree)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func loggedIn(whoAuth):
	TimerFrameHourglass.stop()
	Authing.hide()
	Authed.show()
	PlsWaiter.hide()
	authedMe = whoAuth
	Firebase.Auth.get_user_data()
	#print(String(authedMe))
	firebaseReferencer = Firebase.Database.get_database_reference("sandbox/dd", {})
	userButton.text
	emit_signal("loggedInAuthed", whoAuth)
	pass

func loggedFaile(code,message):
	TimerFrameHourglass.stop()
	Authing.show()
	Authed.hide()
	PlsWaiter.hide()
	emit_signal("loggedFaile",code,message)
	pass

func receiveUserDictionary(userData : FirebaseUserData):
	userDictionaryData = {
		"local_id" : userData.local_id,
		"email" :userData.email,
		"email_verified" :userData.email_verified,
		"password_updated_at" :userData.password_updated_at,
		"last_login_at": userData.last_login_at,
		"created_at" :userData.created_at,
		
		"provider_id" :userData.provider_id,
		"display_name" :userData.display_name,
		"photo_url" :userData.photo_url,
	}
	firebaseReferencer.update("pengguna/" + String(userDictionaryData["local_id"]), userDictionaryData)
	emit_signal("userDataDictionary", userDictionaryData)
	pass

func receiveUserData(userData):
	
	emit_signal("userDataGet",userData)
	receiveUserDictionary(userData)
	pass

func tryLogin():
	Authing.hide()
	Authed.hide()
	PlsWaiter.show()
	Firebase.Auth.login_with_email_and_password(UserNameText, PasswordText)
	TimerFrameHourglass.start()
	pass

func trySignup():
	Authing.hide()
	Authed.hide()
	PlsWaiter.show()
	Firebase.Auth.signup_with_email_and_password(UserNameText, PasswordText)
	TimerFrameHourglass.start()
	pass


func _on_UserMail_text_changed(new_text):
	UserNameText = new_text
	pass # Replace with function body.


func _on_Password_text_changed(new_text):
	PasswordText = new_text
	pass # Replace with function body.


func _on_LOGINbutton_pressed():
	tryLogin()
	pass # Replace with function body.


func _on_SIGNUPbutton_pressed():
	trySignup()
	pass # Replace with function body.

func _on_FirebaseAuth_LoginSuccess(whoAuth):
	print("login success")
	
	loggedIn(whoAuth)
	pass

func _on_FirebaseAuth_LoginFail(code,message):
	print("login faile")
	loggedFaile(code, message)
	pass

func _on_FirebaseAuth_GetUserData(userData):
	print("receive user data")
	receiveUserData(userData)
	pass


func _on_USERbutton_pressed():
	pass # Replace with function body.


func _on_HourglassFramePerSecond_timeout():
	RotateHourglass()
	pass # Replace with function body.
