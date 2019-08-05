extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Gameplay UI controls Character, HP, gameplay values

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal PressPauseButton()
func _on_PauseButton_pressed():
	print("Press Pause Button")
	emit_signal("PressPauseButton")
	pass # Replace with function body.
