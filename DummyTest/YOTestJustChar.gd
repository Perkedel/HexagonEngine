extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var Char1 = $JustKinematic
@onready var Char2 = $JustKinematic2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				Char1.activate_current()
				Char2.deactivate_current()
#				Char1.current = true
#				Char2.current = false
				pass
			if event.keycode == KEY_2:
				Char2.activate_current()
				Char1.deactivate_current()
#				Char2.current = true
#				Char1.current = false
				pass
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
