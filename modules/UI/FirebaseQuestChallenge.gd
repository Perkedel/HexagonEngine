extends VBoxContainer

var emailFill:String
var passwordFill:String
var confirmPassFill:String
var RememberMeNow:bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var selectAuth = $SelectAuthMode 
onready var Loginer = $LoginNow
onready var Registre = $RegisterNow
onready var Logedin = $LoggedInYay
onready var Loadinger = $LoadingNow
onready var http = $HTTPRequest
onready var RegStatus = $RegisterNow/RegisterStatusLabel
onready var LoginStatus = $LoginNow/LoginStatusLabel
onready var SelectStatus = $SelectAuthMode/SelectStatusLabel
onready var AuthMode:int = 0

var HourglassRotateDegree:float = 0
onready var TimePiece = $LoadingNow/PLSWAIT/HourGlassContainer/GravityHourGlass
onready var TimerFrameHourglass = $LoadingNow/PLSWAIT/HourglassFramePerSecond

var user_info: Dictionary

const _dirSecret:String = "user://Rahasia-DO_NOT_SHARE/Firebasers/"
const _fileSecret:String = _dirSecret + "RememberMe-DO_NOT_SHARE-delete_On_Warnet_Gamebot.konfigurasi"
const _encryptFilePass = "Need New Contrast Mouse Yacht Padlock Lamp Paper Keyboard Gamepad Blade Girl Boy Simple Sustain"
var _loginPasswords:Dictionary = {
	emaileing = "",
	passwordeing = "",
}

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
	RememberMeNow = false
	$LoginNow/RememberMeChecko.pressed = false
	$RegisterNow/RememberMeChecki.pressed = false
	_hide_windows()
	selectAuth.show()

func _checkSecretFile():
	var filer = ConfigFile.new()
	
	var direr = Directory.new()
	if direr.dir_exists(_dirSecret):
		pass
	else:
		direr.make_dir_recursive(_dirSecret)
	
	filer.load_encrypted_pass(_fileSecret,_encryptFilePass)
	#filer.load(_fileSecret)
	if not filer.has_section_key("Firebase","Email"):
		filer.set_value("Firebase", "Email", _loginPasswords.emaileing)
	else:
		#_loginPasswords.emaileing = filer.get_value("Firebase", "Email", "")
		emailFill = filer.get_value("Firebase", "Email")
	
	if not filer.has_section_key("Firebase", "Password"):
		filer.set_value("Firebase", "Email", _loginPasswords.passwordeing)
	else:
		#_loginPasswords.emaileing = filer.get_value("Firebase", "Password", "")
		passwordFill = filer.get_value("Firebase", "Password")
	filer.save_encrypted_pass(_fileSecret,_encryptFilePass)
	#filer.save(_fileSecret)
	
	#emailFill = _loginPasswords.emaileing
	#passwordFill = _loginPasswords.passwordeing

func _saveSecretFile():
	var filer = ConfigFile.new()
	filer.load_encrypted_pass(_fileSecret,_encryptFilePass)
	filer.set_value("Firebase", "Email", emailFill)
	filer.set_value("Firebase", "Password", passwordFill)
	filer.save_encrypted_pass(_fileSecret,_encryptFilePass)
	#filer.save(_fileSecret)

func _deleteSecretFile():
	var filer = ConfigFile.new()
	filer.erase_section("Firebase")
	filer.save_encrypted_pass(_fileSecret,_encryptFilePass)
	filer = null
	var direr = Directory.new()
	# https://godotengine.org/qa/11098/how-to-delete-a-save-game
	direr.remove(_fileSecret)
	direr.remove(_dirSecret)

func _preAuthenticate():
	var didRemember = Settingers.getFirebaser("RememberMe")
	RememberMeNow = didRemember
	if didRemember:
		_checkSecretFile()
		if not emailFill.empty() and not passwordFill.empty():
			_authenticateNow()
		else:
			SelectStatus.text = "email or password is empty!"
			Settingers.setFirebaser("RememberMe", false)
			_GoHome()
		pass
	else:
		Settingers.setFirebaser("RememberMe", false)
		_GoHome()
	pass

func _authenticateNow():
	TimerFrameHourglass.start()
	_hide_windows()
	
	Settingers.setFirebaser("RememberMe", RememberMeNow)
	if RememberMeNow:
		_saveSecretFile()
		pass
	else:
		_deleteSecretFile()
	
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
			print("Werror Auth code " + String(result[1]))
			match AuthMode:
				0:
					Loginer.show()
					LoginStatus.text = "Login Werrored code " + String(result[1])
					pass
				1:
					Registre.show()
					RegStatus.text = "Register Werrored code " + String(result[1])
					pass
				_:
					pass
			pass
	Settingers.SettingSave()
	pass

func _deAuthenticateNow():
	
	RememberMeNow = false
	Settingers.setFirebaser("RememberMe", false)
	_deleteSecretFile()
	
	_hide_windows()
	_GoHome()
	pass

func _checkLogin():
	if !passwordFill.empty() && !emailFill.empty():
		_authenticateNow()
	else:
		# I commit sin. sorry!
		if passwordFill.empty():
			print("Password field empty!")
			LoginStatus.text = "Please fill Password!"
		elif emailFill.empty():
			print("Email field empty!")
			LoginStatus.text = "Please fill Email!"
		elif emailFill.empty() && passwordFill.empty():
			print("Email & Password field empty!")
			LoginStatus.text = "Please fill Email & Password!"
	pass

func _checkRegister():
	if confirmPassFill == passwordFill:
		_authenticateNow()
	else:
		print("Confirm not match with pass")
		RegStatus.text = "Password Confirmation field did not match with Password field"
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_preAuthenticate()
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
	_checkLogin()
	pass # Replace with function body.


func _on_AuthenticateRegister_pressed():
	_checkRegister()
	pass # Replace with function body.

# Loginer
func _on_Emaile_TextEntered(text_new):
	emailFill = text_new
	pass # Replace with function body.


func _on_Passwordo_TextEntered(text_new):
	passwordFill = text_new
	_checkLogin()
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
	_checkRegister()
	pass # Replace with function body.

#let's go back
func _on_Login_Now_letsGoBack():
	_GoHome()
	pass # Replace with function body.

func _on_RegisterNow_letsGoBack():
	_GoHome()
	pass # Replace with function body.


func _on_LogoutButton_pressed():
	_deAuthenticateNow()
	pass # Replace with function body.


func _on_RememberMeChecko_toggled(button_pressed):
	RememberMeNow = button_pressed
	pass # Replace with function body.


func _on_RememberMeChecki_toggled(button_pressed):
	RememberMeNow = button_pressed
	pass # Replace with function body.
