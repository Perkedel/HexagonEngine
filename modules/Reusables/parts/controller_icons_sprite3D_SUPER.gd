@tool
extends ControllerSprite3D

@export_group('Billboardings')
@export var faceToCamera:bool = false:
	set(_faceToCamera):
		faceToCamera = _faceToCamera
		if faceToCamera:
#			material_override = billboarderMaterial
			pass
		else:
#			material_override = null
			pass
		pass
@onready var billboarderMaterial: = preload("res://modules/ShadeMaterials/billboarders.tres")

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
	pass

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(path):
		modulate = colorPressed
		pass
	elif event.is_action_released(path):
		modulate = colorNormal
		pass
	# can we just.. flat = true if action_pressed(path) else false asdhfklasjdklf aaaa
#	super._input(event)
	pass
