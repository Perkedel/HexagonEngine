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
signal loggedFaile()

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_LoginSuccess")
	Firebase.Auth.connect("login_failed", self, "on_FirebaseAuth_LoginFail")
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
	print(String(authedMe))
	firebaseReferencer = Firebase.Database.get_database_reference("sandbox/dd", {})
	userButton.text
	emit_signal("loggedInAuthed")
	pass

func loggedFaile():
	TimerFrameHourglass.stop()
	Authing.show()
	Authed.hide()
	PlsWaiter.hide()
	emit_signal("loggedFaile")
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

func _on_FirebaseAuth_LoginFail():
	print("login faile")
	loggedFaile()
	pass


func _on_USERbutton_pressed():
	pass # Replace with function body.


func _on_HourglassFramePerSecond_timeout():
	RotateHourglass()
	pass # Replace with function body.
