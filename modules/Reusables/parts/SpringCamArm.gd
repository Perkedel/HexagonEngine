extends SpringArm

# 3rd person camera arm joint
# https://youtu.be/UpF7wm0186Q

export(float) var mouseSensitivity = 0.05
export(float) var maxTop = 30
export(float) var minBottom = -90
export(bool) var limitLeftRight:bool = false
export(float) var minLeft = 0
export(float) var maxRight = 360

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
		rotation_degrees.x = clamp(rotation_degrees.x, minBottom, maxTop)
		
		# left & right
		rotation_degrees.y -= event.relative.x * mouseSensitivity
		rotation_degrees.y = wrapf(
			clamp(rotation_degrees.y,minLeft,maxRight) if limitLeftRight
			else rotation_degrees.y
			, 0.0, 360.0)
		
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
