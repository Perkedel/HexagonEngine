@tool
extends TextureRect

@export var rotating: bool = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_ignore_rotation(val = true):
#	ignore_rotation = val # reversed "rotating" for Camera2D
	_refreshParams()

func _refreshParams():
	material.set_shader_parameter("rotating",rotating)

# Called when the node enters the scene tree for the first time.
func _ready():
	_refreshParams()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
