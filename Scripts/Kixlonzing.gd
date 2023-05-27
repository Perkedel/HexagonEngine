extends Node

@export var KixlonzWalletPath:String = "res://Currency/Kixlonz.txt" 
#"user://Currency/Kixlonz.txt" # "res://Currency/Kixlonz.txt"
var KixlonzFile:FileAccess
@export var KixlonzCurrency:float = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func LoadKixlonz():
#	KixlonzFile = File.new()
	KixlonzFile = FileAccess.open(KixlonzWalletPath, FileAccess.READ)
	var formater:String
	if KixlonzFile.get_open_error() == OK:
		formater = KixlonzFile.get_as_text()
		pass
	else:
		formater = "10"
		KixlonzFile.open(KixlonzWalletPath, FileAccess.WRITE)
		KixlonzFile.store_string(formater)
		pass
	KixlonzCurrency = float(formater)
	KixlonzFile.close()
	pass
func SaveKixlonz():
#	KixlonzFile = File.new()
	KixlonzFile.open(KixlonzWalletPath, FileAccess.WRITE)
#	var formatter:String = KixlonzCurrency
#	var formatter:String = "10" # float to string missing
	var formatter:String = String.num(KixlonzCurrency) # nvm found it
	KixlonzFile.store_string(formatter)
	KixlonzFile.close()
	pass
func AdRewardUserNow(HowMuch:float):
	KixlonzCurrency+=HowMuch
	SaveKixlonz()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	LoadKixlonz()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
