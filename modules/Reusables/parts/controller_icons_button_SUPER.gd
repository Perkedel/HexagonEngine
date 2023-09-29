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
	var toRelease = InputEventAction.new()
	toRelease.action = path
	toRelease.pressed = false
	Input.parse_input_event(toRelease)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	super._process(delta)
	pass

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(path):
		flat = false
		pass
	elif event.is_action_released(path):
		flat = true
		pass
	# can we just.. flat = true if action_pressed(path) else false asdhfklasjdklf aaaa
#	super._input(event)
	pass

func _on_pressed() -> void:
	_manuallyPressit()
	pass # Replace with function body.


func _on_button_up() -> void:
#	_manuallyReleaseIt()
	pass # Replace with function body.
