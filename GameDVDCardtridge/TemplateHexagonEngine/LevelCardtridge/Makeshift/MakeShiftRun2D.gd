extends RigidBody2D
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
signal reportHP(level)
signal reportScore(number)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


onready var Direction = Vector2()
onready var DirectionRaw = Vector2()
onready var DirectionInputMap = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#x_move = Input.get_action_strength("ui_left")
	#y_move = Input.get_action_strength("ui_up")
	x_move = Input.get_joy_axis(0, JOY_ANALOG_LX)
	y_move = Input.get_joy_axis(0, JOY_ANALOG_LY)
	#x_move = Input.get_action_strength("AnalogKiri_x")
	#y_move = Input.get_action_strength("AnalogKiri_y")
	x_InputMap = clamp(Input.get_action_strength("AnalogKiri_x") - Input.get_action_strength("AnalogKiri_x-"), -1,1) 
	y_InputMap = clamp(Input.get_action_strength("AnalogKiri_y-") - Input.get_action_strength("AnalogKiri_y"), -1,1)
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
	
	Direction = Vector2(x_deadzone, y_deadzone)
	DirectionRaw = Vector2(x_move, y_move)
	DirectionInputMap = Vector2(x_InputMap, y_InputMap)
	#DirectionRaw = DirectionRaw.normalized()
	#Direction = Direction.normalized()
	#DirectionInputMap = DirectionInputMap.normalized()
	
	#print("AnalogKiri: " + String(x_move) + ", " + String(y_move))
	#print("AnalogKiri Action Strength: " + String(Input.get_action_strength("AnalogKiri_x")) + ", " + String(Input.get_action_strength("AnalogKiri_y")))
	
	# https://godotengine.org/article/handling-axis-godot
	print("AnalogKiri Action Strength: " + String(x_InputMap) + ", " + String(y_InputMap))
	#print("Raw Map : " + String(Input.get_action_strength("AnalogKiri_x")) + ", " + String(Input.get_action_strength("AnalogKiri_y")))
	#translate(Direction * 5)
	apply_impulse(Vector2.ZERO, DirectionInputMap * 5)
	pass


#func _input(event):
#	x_move = Input.get_joy_axis()
#	pass


