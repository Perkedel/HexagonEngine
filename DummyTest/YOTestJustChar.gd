extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Char1 = $JustKinematic
onready var Char2 = $JustKinematic2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_1:
				Char1.current = true
				pass
			if event.scancode == KEY_2:
				Char2.current = true
				pass
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
