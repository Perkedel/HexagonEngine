extends RigidBody

# Pls walk

# https://godotengine.org/article/godot-3-4-is-released#input

export(NodePath) var catchCamera:NodePath
export(float) var WALK_FORCE:float = 1
export(float) var WALK_DEADZONE:float = .25
export(float) var JUMP_STRENGTH:float = 20.0
export(float) var JUMP_TOKEN:int = 2

onready var jalan:Vector2 = Vector2.ZERO # walk right now
onready var loncatRightNow:int = 2 # jump token right now 
onready var floored:bool = true

onready var _springArm:SpringArm = $SpringArm

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func catchTheCamera():
	if catchCamera:
		
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	jalan = WALK_FORCE * Input.get_vector("Jalan_Kiri", "Jalan_Kanan", "Jalan_Depan", "Jalan_Belakang", WALK_DEADZONE)
	
	if jalan != Vector2.ZERO:
		apply_central_impulse(Vector3(jalan.x,0.0,jalan.y))
		pass
	
	
	pass

func _input(event):
	
	pass
