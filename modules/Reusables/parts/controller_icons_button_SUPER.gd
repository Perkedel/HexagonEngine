@tool
extends ControllerButton

# Extend Input Prompt Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

func _manuallyPressit():
#	Input.action_press(path)
	var toPress = InputEventAction.new()
	toPress.action = path
	toPress.pressed = true
	Input.parse_input_event(toPress)
	pass

func _manuallyHoldIt():
	pass

func _manuallyReleaseIt():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	super._process(delta)
	pass

func _on_pressed() -> void:
	_manuallyPressit()
	pass # Replace with function body.
