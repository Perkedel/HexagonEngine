extends KinematicBody

# Pls walk

# https://godotengine.org/article/godot-3-4-is-released#input
# https://youtu.be/UpF7wm0186Q GDQuest how to 3D kinematic character

export(NodePath) var catchCamera:NodePath
export(float) var WALK_SPEED:float = 5
export(float) var WALK_DEADZONE:float = .25
export(float) var JUMP_STRENGTH:float = 20.0
export(float) var JUMP_TOKEN:int = 1
export(float) var GRAVITATION:float = 50
export(bool) var smoothCharRotate:bool = true
export(float) var smoothRotateSpeed:float = 10
export(bool) var rotateOnFloorOnly:bool = false #if true the form rotates only if on floor

onready var jalan:Vector2 = Vector2.ZERO # walk right now
onready var loncatRightNow:int = 1 # jump token right now 
onready var floored:bool = true
onready var is_jumping:bool = false

var _velocity:Vector3 = Vector3.ZERO #total velocity to be here
var _snap_vector:Vector3 = Vector3.DOWN
var _lookAtDirection:Vector2 = Vector2.UP
var _smoothDirection:Vector3 = Vector3.FORWARD

onready var _springArm:SpringArm = $SpringCamArm
onready var _form:Spatial = $FormSlot 
onready var _frontRef = $FrontRef

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
	# smooth look direction NovemberDev
#	_smoothDirection.y = 0
#	global_transform.basis = smooth_look_at(global_transform, global_transform.origin - _smoothDirection, delta)
	
	# make spring arm also follow this thing translation
	_springArm.translation = translation
#	_frontRef.rotation_degrees.y = _springArm.rotation_degrees.y
	
	pass

func _physics_process(delta):
	# move direction based on cam rotation
	var arah_gerak = Vector3.ZERO
	arah_gerak.x = Input.get_axis("Jalan_Kiri", "Jalan_Kanan")
	arah_gerak.z = Input.get_axis("Jalan_Depan", "Jalan_Belakang")
	arah_gerak = arah_gerak.rotated(Vector3.UP,_springArm.rotation.y).normalized()
	
	# handle velocity
	_velocity.x = WALK_SPEED * arah_gerak.x
	_velocity.z = WALK_SPEED * arah_gerak.z
	_velocity.y -= GRAVITATION * delta
	
	jalan = WALK_SPEED * Input.get_vector("Jalan_Kiri", "Jalan_Kanan", "Jalan_Depan", "Jalan_Belakang", WALK_DEADZONE)
	
	# handle jump
	floored = is_on_floor() and _snap_vector == Vector3.ZERO
	#TODO: utilize jump token
	is_jumping = is_on_floor() and Input.is_action_just_pressed("Melompat")
	var extraJumping:bool = Input.is_action_just_pressed("Melompat") and loncatRightNow > 0 and not is_on_floor()
	if is_jumping:
		_velocity.y = JUMP_STRENGTH
		_snap_vector = Vector3.ZERO
		
	elif floored:
		_snap_vector = Vector3.DOWN
		loncatRightNow = JUMP_TOKEN
	
	# the double or more jump
	if extraJumping:
		loncatRightNow -= 1
		_velocity.y = JUMP_STRENGTH
	
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	# rotate form model towards where it moves
	if arah_gerak.length() > .3 and ((rotateOnFloorOnly and is_on_floor()) or (not rotateOnFloorOnly)):
		_lookAtDirection = Vector2(arah_gerak.z, arah_gerak.x)
		# with smooth rotate simplificed by Konstantin Glubev replying NovemberDev
		_form.rotation.y = lerp_angle(_form.rotation.y, _lookAtDirection.angle(), delta * smoothRotateSpeed) if smoothCharRotate else _lookAtDirection.angle()
		_frontRef.rotation.y = lerp_angle(_frontRef.rotation.y, _lookAtDirection.angle(), delta * smoothRotateSpeed) if smoothCharRotate else _lookAtDirection.angle()
		pass
	
	if jalan != Vector2.ZERO:
		
		pass
	
	pass

# comment of NovemberDev
func smooth_look_at(t : Transform, dir, delta):
	 return t.basis.slerp(t.looking_at(dir, Vector3.UP).basis, delta)

func _input(event):
	
	pass
