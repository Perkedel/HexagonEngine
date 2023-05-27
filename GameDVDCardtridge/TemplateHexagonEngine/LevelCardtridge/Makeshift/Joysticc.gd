extends RigidBody2D

@export (float) var x_InputMap
@export (float) var y_InputMap
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var DirectionInputMap = Vector2()
@onready var x_init = position.x #961.26
@onready var y_init = position.y #550.175
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	x_InputMap = clamp(Input.get_action_strength("AnalogKiri_x") - Input.get_action_strength("AnalogKiri_x-"), -1,1) 
	y_InputMap = clamp(Input.get_action_strength("AnalogKiri_y-") - Input.get_action_strength("AnalogKiri_y"), -1,1)
	DirectionInputMap = Vector2(x_InputMap, y_InputMap)
	#DirectionInputMap = DirectionInputMap.normalized()
	
	position.x = x_init + DirectionInputMap.x * 50
	position.y = y_init + DirectionInputMap.y * 50
	pass
