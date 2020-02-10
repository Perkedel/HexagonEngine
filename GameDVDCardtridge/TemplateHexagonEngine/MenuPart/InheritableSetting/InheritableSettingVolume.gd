extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var VariableName = "Volume"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	$LabelContainer/Label.text = VariableName
	$LabelContainer/LabelValue.text = String($HBoxContainer/HSlider.value) + " dB"
	pass

func SetVolume(value : float) -> void:
	$HBoxContainer/HSlider.value = value
	print("Slider: " + String(value))
	pass

# https://godotengine.org/qa/60870/how-do-i-change-datatype-of-a-signal-using-gdscript
# help wanted
# signal ValueOfIt(value: float)
signal ValueOfIt(value)
func _on_HSlider_value_changed(value, valou):
	emit_signal("ValueOfIt", value)
	print("Slider: " + String(value))
	pass # Replace with function body.

signal HasChanged
func _on_HSlider_changed():
	emit_signal("HasChanged")
	pass # Replace with function body.

signal SliderReleased
func _on_HSlider_gui_input(event : InputEvent):
	if event.is_action_released("ui_mouse_left"):
		emit_signal("SliderReleased")
		pass
	pass # Replace with function body.
