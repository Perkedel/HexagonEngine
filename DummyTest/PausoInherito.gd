extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# https://docs.godotengine.org/en/latest/tutorials/misc/pausing_games.html
# https://www.youtube.com/watch?v=Jf7F3JhY9Fg

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hands.process_mode = PROCESS_MODE_ALWAYS
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		get_tree().paused = true
		pass
	pass
