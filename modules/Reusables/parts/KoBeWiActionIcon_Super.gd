@tool
extends "res://addons/ActionIcon/ActionIcon.gd"

#Kobewi's Action Icon
@export_group('Feedback')
@export var colorNormal:Color = Color.WHITE
@export var colorPressed:Color = Color.GRAY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

func _manuallyPressit():
#	Input.action_press(path)
	var toPress = InputEventAction.new()
	toPress.action = action_name
	toPress.pressed = true
	Input.parse_input_event(toPress)
	pass

func _manuallyHoldIt():
	pass

func _manuallyReleaseIt():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(action_name):
#		self_modulate = colorPressed
		pass
	elif event.is_action_released(action_name):
#		self_modulate = colorNormal
		pass
	super._input(event)

func _notification(what: int) -> void:
	match(what):
		_:
			pass
	
	super._notification(what)
