extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# https://www.youtube.com/watch?v=L0anvhjwdU8

# Called when the node enters the scene tree for the first time.
func _ready():
	$Popup.popup_centered()
	$WindowDialog.popup()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(2):
		$PopupMenu.popup()
		pass
	pass
