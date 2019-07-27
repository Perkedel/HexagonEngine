extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	var IsKeyPress
	var IsKeyCode
	var Formatsing
	var Wroding
	if event is InputEventKey:
		# https://godotengine.org/qa/30582/how-to-detect-which-key-is-pressed
		# https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
		IsKeyPress = OS.get_scancode_string(event.scancode)
		IsKeyCode = OS.find_scancode_from_string(IsKeyPress)
		# https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_format_string.html
		Formatsing = "Name: %s; Code: %s"
		Wroding = Formatsing % [IsKeyPress, IsKeyCode]
		print(Wroding)
		pass
	#print(Wroding)
	pass


func _on_Button_pressed():
	print("Small Text")
	pass # Replace with function body.
