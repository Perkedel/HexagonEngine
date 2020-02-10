extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var VariableName = "Volume"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal ValueOfIt(value: float)
func _on_HSlider_value_changed(value : float) -> void:
	emit_signal("ValueOfIt", value)
	pass # Replace with function body.

signal HasChanged
func _on_HSlider_changed():
	emit_signal("HasChanged")
	pass # Replace with function body.
