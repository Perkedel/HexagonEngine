extends VBoxContainer

var emailFill:String
var passwordFill:String
var confirmPassFill:String
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var selectAuth = $SelectAuthMode 
onready var Loginer = $LoginNow
onready var Registre = $RegisterNow
onready var Logedin = $LoggedInYay
onready var Loadinger = $LoadingNow
onready var http = $HTTPRequest
onready var AuthMode:int = 0

var HourglassRotateDegree:float = 0
onready var TimePiece = $LoadingNow/PLSWAIT/HourGlassContainer/GravityHourGlass
onready var TimerFrameHourglass = $LoadingNow/PLSWAIT/HourglassFramePerSecond

var user_info: Dictionary

func RotateHourglass():
	HourglassRotateDegree += 2
	if HourglassRotateDegree >= 360:
		HourglassRotateDegree = HourglassRotateDegree - 360
		pass    
	TimePiece.set_rotation_degrees(HourglassRotateDegree)
	pass

func _hide_windows():
	selectAuth.hide()
	Loginer.hide()
	Registre.hide()
	Logedin.hide()
	Loadinger.hide()

func _GoHome():
	_hide_windows()
	selectAuth.show()

func _authenticateNow():
	TimerFrameHourglass.start()
	_hide_windows()
	Loadinger.show()
	match AuthMode:
		0:
			FirebaseQuest.login(emailFill, passwordFill, http)
			pass
		1:
			FirebaseQuest.register(emailFill, passwordFill, http)
			pass
		_:
			pass
	var result = yield(http,"request_completed") as Array
	# https://github.com/GDQuest/godot-demos/blob/master/2019/05-21-firebase-firestore/end/static/Firebase.gd
	_hide_windows()
	match result[1]:
		200:
			user_info = FirebaseQuest.user_info
			
			Logedin.show()
			pass
		_:
			print("Werror Auth")
			match AuthMode:
				0:
					Loginer.show()
					pass
				1:
					Registre.show()
					pass
				_:
					pass
			pass
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	_GoHome()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RegistButton_pressed():
	AuthMode = 1
	_hide_windows()
	Registre.show()
	pass # Replace with function body.


func _on_LoginButton_pressed():
	AuthMode = 0
	_hide_windows()
	Loginer.show()
	pass # Replace with function body.



func _on_HourglassFramePerSecond_timeout():
	RotateHourglass()
	pass # Replace with function body.


func _on_AuthenticateLogin_pressed():
	_authenticateNow()
	pass # Replace with function body.


func _on_AuthenticateRegister_pressed():
	_authenticateNow()
	pass # Replace with function body.

# Loginer
func _on_Emaile_TextEntered(text_new):
	emailFill = text_new
	pass # Replace with function body.


func _on_Passwordo_TextEntered(text_new):
	passwordFill = text_new
	_authenticateNow()
	pass # Replace with function body.


func _on_Emaile_TextChanged(text_new):
	emailFill = text_new
	pass # Replace with function body.


func _on_Passwordo_TextChanged(text_new):
	passwordFill = text_new
	pass # Replace with function body.

# Registerer
func _on_Emailen_TextChanged(text_new):
	emailFill = text_new
	pass # Replace with function body.


func _on_ConfirmPassword_TextChanged(text_new):
	confirmPassFill = text_new
	_authenticateNow()
	pass # Replace with function body.


func _on_Passworde_TextChanged(text_new):
	passwordFill = text_new
	pass # Replace with function body.


func _on_Passworde_TextEntered(text_new):
	passwordFill = text_new
	#_authenticateNow()
	pass # Replace with function body.


func _on_Emailen_TextEntered(text_new):
	emailFill = text_new
	#_authenticateNow()
	pass # Replace with function body.


func _on_ConfirmPassword_TextEntered(text_new):
	confirmPassFill = text_new
	_authenticateNow()
	pass # Replace with function body.

#let's go back
func _on_Login_Now_letsGoBack():
	_GoHome()
	pass # Replace with function body.

func _on_RegisterNow_letsGoBack():
	_GoHome()
	pass # Replace with function body.
