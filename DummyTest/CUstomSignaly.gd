extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@export var Wrind: String = "Wrindeeeeee"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal Emiro(Strong)

func _on_Button_pressed(extra_arg_0, extra_arg_1):
	emit_signal("Emiro", Wrind)
	pass # Replace with function body.
