tool
extends TextureRect

export(bool) var rotating = true setget set_rotating
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_rotating(isRotate:bool):
	rotating = isRotate
	_refreshParams()

func _refreshParams():
	material.set_shader_param("rotating",rotating)

# Called when the node enters the scene tree for the first time.
func _ready():
	_refreshParams()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
