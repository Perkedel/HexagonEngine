extends SpringArm3D

# 3rd person camera arm joint
# https://youtu.be/UpF7wm0186Q

@export var current: bool:bool = false: get = get_current, set = set_current # Is this the one that active?
@export var autoCheckCam: bool:bool = false
@export var mouseSensitivity: float = 0.05
@export var analogSensitivity: float = 1
@export var maxTop: float = 30
@export var minBottom: float = -90
@export var limitLeftRight: bool:bool = false
@export var minLeft: float = 0
@export var maxRight: float = 360
@export var deadzoning: float = .15

var _joyMoveX:float
var _joyMoveY:float
var _camCurrent:bool: get = get_camCurrent, set = set_camCurrent
var _lastCamCurrent:bool = false
var _lastCurrent:bool = false
@onready var theCam = $Camera3D

signal on_camCurrent(value)

func set_current(value:bool):
	current = value
#	if _lastCurrent != value:
#		_lastCurrent = value
#	theCam.current = value
	pass

func get_current():
	return current
	pass

func set_camCurrent(value:bool):
	_camCurrent = value
#	if theCam.current != _lastCamCurrent:
#		current = value
#		_lastCamCurrent = value
#		emit_signal("on_camCurrent", value)
	pass

func get_camCurrent():
	return _camCurrent
	pass

func checkCamCurrent():
	if _lastCamCurrent != theCam.current:
		_camCurrent = theCam.current
		_lastCamCurrent = _camCurrent
		emit_signal("on_camCurrent",_camCurrent)
	pass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func activate_current():
	current = true
	theCam.current = true
	checkCamCurrent()

func deactivate_current():
	current = false
	theCam.current = false
	checkCamCurrent()

# Called when the node enters the scene tree for the first time.
func _ready():
	_lastCamCurrent = theCam.current
	_lastCurrent = current
	checkCamCurrent()
	set_as_top_level(true)
	#TODO: enable only if focused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass # Replace with function body.

func _unhandled_input(event):
	if current:
		if event is InputEventMouseMotion:
			# Up & down
			rotation_degrees.x -= event.relative.y * mouseSensitivity
			# then clamp the x
			rotation_degrees.x = clamp(rotation_degrees.x, minBottom, maxTop)
			
			# left & right
			rotation_degrees.y -= event.relative.x * mouseSensitivity
			# then wrapf the y
			rotation_degrees.y = wrapf(
				clamp(rotation_degrees.y,minLeft,maxRight) if limitLeftRight
				else rotation_degrees.y
				, 0.0, 360.0)
			pass
		
		if event is InputEventJoypadMotion:
			if event.get_axis() == JOY_ANALOG_RX:
				var value = event.get_axis_value() if event.get_axis_value() > deadzoning or event.get_axis_value() < -deadzoning else 0
				_joyMoveY = value * analogSensitivity
			if event.get_axis() == JOY_ANALOG_RY:
				var value = event.get_axis_value() if event.get_axis_value() > deadzoning or event.get_axis_value() < -deadzoning else 0
				_joyMoveX = value * analogSensitivity
			pass
	
	#	if event is InputEventAction:
	#		_joyMoveX = (event.get_action_strength("AnalogKanan_x") - event.get_action_strength("AnalogKanan_x-")) * analogSensitivity
	#
	#		_joyMoveY = (event.get_action_strength("AnalogKanan_y") - event.get_action_strength("AnalogKanan_y-")) * analogSensitivity
		pass
	pass

func _physics_process(delta):
	rotation_degrees.x -= _joyMoveX
	rotation_degrees.x = clamp(rotation_degrees.x, minBottom, maxTop)
	rotation_degrees.y -= _joyMoveY
	rotation_degrees.y = wrapf(clamp(rotation_degrees.y,minLeft,maxRight) if limitLeftRight else rotation_degrees.y, 0.0, 360.0)
#	checkCamCurrent()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if autoCheckCam:
#		checkCamCurrent()
	pass
