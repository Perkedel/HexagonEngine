extends RigidBody
export (float) var x_move
export (float) var y_move
export (float) var x_InputMap
export (float) var y_InputMap
export (float) var deadzone_circle = .5
onready var x_deadzone = 0
onready var y_deadzone = 0


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# https://www.youtube.com/watch?v=LfbOOA3dmFo&t=209s
# https://www.youtube.com/watch?v=Etpq-d5af6M&t=183s
# https://www.youtube.com/watch?v=ZyzTwWLOGiY
# https://www.youtube.com/watch?v=Lxx6M1AQVeU
# https://www.youtube.com/watch?v=uGyEP2LUFPg&t=65s
# https://godotengine.org/article/handling-axis-godot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var Direction = Vector3()
onready var DirectionRaw = Vector3()
onready var DirectionInputMap = Vector3()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	x_move = Input.get_joy_axis(0, JOY_ANALOG_LX)
	y_move = Input.get_joy_axis(0, JOY_ANALOG_LY)
	x_InputMap = Input.get_action_strength("AnalogKiri_x") - Input.get_action_strength("AnalogKiri_x-")
	y_InputMap = Input.get_action_strength("AnalogKiri_y-") - Input.get_action_strength("AnalogKiri_y")
	x_deadzone = 0
	y_deadzone = 0
	
	if x_move < -deadzone_circle || x_move > deadzone_circle:
		x_deadzone = clamp(x_move, -1, 1)
		pass
	else:
		x_deadzone = 0 
		pass
	
	if y_move < -deadzone_circle || y_move > deadzone_circle:
		y_deadzone = clamp(y_move,-1,1)
		pass
	else:
		y_deadzone = 0 
		pass
	
	Direction = Vector3(x_deadzone, 0, y_deadzone)
	DirectionRaw = Vector3(x_move, 0, y_move)
	DirectionInputMap = Vector3(x_InputMap,0, y_InputMap)
	#DirectionRaw = DirectionRaw.normalized()
	#Direction = Direction.normalized()
	#DirectionInputMap = DirectionInputMap.normalized()
	
	translate(DirectionInputMap * delta)
	pass
