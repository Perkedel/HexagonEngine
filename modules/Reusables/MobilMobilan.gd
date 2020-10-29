extends VehicleBody

export var Accelerations : float = 100
export var Steerings : float = .75
export var Braker : float = 1
var steereo = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	engine_force = Accelerations * ((Input.get_action_strength("Jalan_Depan") + Input.get_action_strength("TembakKanan")) - (Input.get_action_strength("Jalan_Belakang") + Input.get_action_strength("TembakKiri")))
	steereo = -Steerings * (Input.get_action_strength("Jalan_Kanan") - Input.get_action_strength("Jalan_Kiri"))
	steering = steereo
	print("Steer ", steering)
	brake = Braker * Input.get_action_strength("Keyboard_Space")
	pass
