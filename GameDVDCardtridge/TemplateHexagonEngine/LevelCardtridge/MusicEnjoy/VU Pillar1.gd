extends RigidBody2D

@onready var Y_init = position.y
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# https://github.com/godotengine/godot-demo-projects/blob/master/audio/spectrum/show_spectrum.gd
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func SetAddHeight(value : float):
	position.y = Y_init - value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position.y+=1
	pass
