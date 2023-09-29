@tool
extends ControllerTextureRect

# Can you please add Interface instead, so different class from different parent can have same
# methods, and is typeable to expect has method even class is entirely different from one
# another.

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

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(path):
		self_modulate = colorPressed
		pass
	elif event.is_action_released(path):
		self_modulate = colorNormal
		pass
	# can we just.. flat = true if action_pressed(path) else false asdhfklasjdklf aaaa
#	super._input(event)
	pass
