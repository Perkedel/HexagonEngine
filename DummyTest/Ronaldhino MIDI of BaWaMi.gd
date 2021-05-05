extends Node

# https://youtu.be/8pj1p42H2Kg
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const RonaldhinoPath = "D:\\PRIVATE FOLDER\\FILE JOEL ROBERT\\MIDI\\Excal\\RONALDINHO.mid"
const BaWaMiPath = "C:\\Users\\joelr\\Documents\\kolmorotzzet (kolmorotshitt)\\Artistic Setups\\Robbi985 aka SomethingUnreal\\BaWaMI\\BaWaMi.exe"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Button_pressed():
	#OS.shell_open(BaWaMiPath)
	var errore = OS.shell_open(BaWaMiPath + " /playnow '" + RonaldhinoPath + "'")
	if errore == OK:
		pass
	else :
		print(errore)
	pass # Replace with function body.
