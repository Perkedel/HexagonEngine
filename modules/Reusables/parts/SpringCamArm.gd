extends SpringArm

# 3rd person camera arm joint
# https://youtu.be/UpF7wm0186Q

export(float) var mouseSensitivity = 0.05
export(float) var analogSensitivity = 1
export(float) var maxTop = 30
export(float) var minBottom = -90
export(bool) var limitLeftRight:bool = false
export(float) var minLeft = 0
export(float) var maxRight = 360
export(float) var deadzoning = .15

var _joyMoveX:float
var _joyMoveY:float

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	#TODO: enable only if focused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass # Replace with function body.

func _unhandled_input(event):
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

func _physics_process(delta):
	rotation_degrees.x -= _joyMoveX
	rotation_degrees.x = clamp(rotation_degrees.x, minBottom, maxTop)
	rotation_degrees.y -= _joyMoveY
	rotation_degrees.y = wrapf(clamp(rotation_degrees.y,minLeft,maxRight) if limitLeftRight else rotation_degrees.y, 0.0, 360.0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
