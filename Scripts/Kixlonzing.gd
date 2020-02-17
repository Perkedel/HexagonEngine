extends Node

export (String) var KixlonzWalletPath = "res://Currency/Kixlonz.txt" 
#"user://Currency/Kixlonz.txt" # "res://Currency/Kixlonz.txt"
var KixlonzFile
export (float) var KixlonzCurrency = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func LoadKixlonz():
	KixlonzFile = File.new()
	KixlonzFile.open(KixlonzWalletPath, File.READ)
	var formater = KixlonzFile.get_as_text()
	KixlonzCurrency = float(formater)
	KixlonzFile.close()
	pass
func SaveKixlonz():
	KixlonzFile = File.new()
	KixlonzFile.open(KixlonzWalletPath, File.WRITE)
	var formatter = String(KixlonzCurrency)
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
