extends KinematicBody

# Pls walk

# https://godotengine.org/article/godot-3-4-is-released#input
# https://youtu.be/UpF7wm0186Q GDQuest how to 3D kinematic character

export(bool) var current:bool = false setget set_current, get_current # Is this the one that active?
export(NodePath) var catchCamera:NodePath
export(float) var WALK_SPEED:float = 5
export(float) var SPRINT_SPEED:float = 10
export(float) var CROUCH_SPEED:float = 2.5
export(float) var DIVE_SPEED:float = 20
export(float) var BONUS_UNDIVE_SPEED:float = 30 # when just right when diven to floor then undive, just like Hat Kid
export(float) var DIVE_VEER_SPEED:float = 4
export(float) var DIVE_SLIDE_TIME:float = 3
export(float) var WALK_DEADZONE:float = .25
export(float) var JUMP_STRENGTH:float = 20.0
export(float) var JUMP_TOKEN:int = 1
export(float) var GRAVITATION:float = 50
export(bool) var smoothCharRotate:bool = true
export(float) var smoothRotateSpeed:float = 10
export(bool) var rotateOnFloorOnly:bool = false #if true the form rotates only if on floor

# Artindi's Special Coyote Time
var shouldCoyoteJump:bool = false
var _sparseCoyoteTimed:bool = false
export(float) var howLongCoyoteTime:float = .5
export(float) var howLongStickyLoncatButton:float = .1

onready var useSpeed:float = 5
onready var jalan:Vector2 = Vector2.ZERO # walk right now
onready var loncatRightNow:int = 1 # jump token right now 
onready var floored:bool = true
onready var is_jumping:bool = false
onready var is_crouching:bool = false
onready var _press_crouch:bool = false
onready var _just_press_crouch:bool = false

var _mode:int = 0
# 0 = walk
# 1 = crouch
# 2 = dive
var _last_arah_gerak:Vector3
var _velocity:Vector3 = Vector3.ZERO #total velocity to be here
var _dive_towards:Vector3
var _snap_vector:Vector3 = Vector3.DOWN
var _lookAtDirection:Vector2 = Vector2.UP
var _smoothDirection:Vector3 = Vector3.FORWARD
var _startDiving:bool = false
var _divenCollided:bool = false

onready var _collider:CollisionShape = $CollideMe
onready var _springArm:SpringArm = $SpringCamArm
onready var _form:Spatial = $FormSlot 
onready var _frontRef = $FrontRef

func set_current(value:bool):
	current = value
#	_springArm.current = value
	_springArm.set_current(value)
	pass

func get_current():
	current = _springArm.current
	return current
	pass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func activate_current():
	current = true

func catchTheCamera():
	if catchCamera:
		
		pass
	pass

func checkCurrent():
	if current != _springArm.current:
		_springArm.current = current
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	checkCurrent()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# make spring arm also follow this thing translation
	_springArm.translation = translation
#	_frontRef.rotation_degrees.y = _springArm.rotation_degrees.y
	
	pass

func _physics_process(delta):
	# analog movement vector
	var gerakan:Vector2 = Input.get_vector("Jalan_Kiri", "Jalan_Kanan", "Jalan_Belakang", "Jalan_Depan", WALK_DEADZONE)
	
	# move direction based on cam rotation
	var arah_gerak = Vector3.ZERO
	if current:
		arah_gerak.x = Input.get_axis("Jalan_Kiri", "Jalan_Kanan")
		arah_gerak.z = Input.get_axis("Jalan_Depan", "Jalan_Belakang")
	arah_gerak = arah_gerak.rotated(Vector3.UP,_springArm.rotation.y).normalized()
	
	# record last direction before zero magnitude
	_last_arah_gerak = arah_gerak if arah_gerak.length() > 0 else _last_arah_gerak
	
	# handle velocity
	match(_mode):
		0:
			_velocity.x = WALK_SPEED * arah_gerak.x
			_velocity.z = WALK_SPEED * arah_gerak.z
		1:
			_velocity.x = CROUCH_SPEED * arah_gerak.x
			_velocity.z = CROUCH_SPEED * arah_gerak.z
		2:
			_velocity.x = _dive_towards.x + (arah_gerak.x * DIVE_VEER_SPEED)
			_velocity.z = _dive_towards.z + (arah_gerak.z * DIVE_VEER_SPEED)
		_:
			_velocity.x = WALK_SPEED * arah_gerak.x
			_velocity.z = WALK_SPEED * arah_gerak.z
	_velocity.y -= GRAVITATION * delta
	
	jalan = WALK_SPEED * gerakan
	
	# handle jump
	floored = is_on_floor() and _snap_vector == Vector3.ZERO
	is_jumping = (is_on_floor() or shouldCoyoteJump) and Input.is_action_just_pressed("Melompat") and current
	var extraJumping:bool = Input.is_action_just_pressed("Melompat") and loncatRightNow > 0 and not (is_on_floor() or shouldCoyoteJump) and current
	if is_jumping:
		_velocity.y = JUMP_STRENGTH
		_snap_vector = Vector3.ZERO
		shouldCoyoteJump = false
	elif floored:
		_snap_vector = Vector3.DOWN
		loncatRightNow = JUMP_TOKEN
		shouldCoyoteJump = true
		_sparseCoyoteTimed = false
	
	# the double or more jump
	if extraJumping:
		loncatRightNow -= 1
		_velocity.y = JUMP_STRENGTH
		_snap_vector = Vector3.ZERO
		shouldCoyoteJump = false
	
	# rest of the ground check
	if is_on_floor():
		_startDiving = false
		pass
	else:
		coyoteTime()
		pass
	
	# Hat Kid dive whoosh & Crouch
	_press_crouch = Input.is_action_pressed("Menyelam_Whoosh") and current
	_just_press_crouch = Input.is_action_just_pressed("Menyelam_Whoosh") and current
	if _press_crouch:
		_collider.rotation_degrees.x = 0
		if _startDiving:
			_mode = 2
		else:
			_mode = 1
		pass
	else:
		_mode = 0
		_collider.rotation_degrees.x = -90
		pass
	
	if (not is_on_floor() or arah_gerak.length() > 0.01) and _just_press_crouch:
		_lookAtDirection = Vector2(arah_gerak.z, arah_gerak.x).rotated(-rotation.y).normalized() if arah_gerak.length() > 0 else _lookAtDirection
		dive_now(_last_arah_gerak)
		
		_collider.rotation.y = _lookAtDirection.angle()
		_form.rotation.y = _lookAtDirection.angle()
		_frontRef.rotation.y = _lookAtDirection.angle()
		pass
	elif _just_press_crouch:
		pass
	
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	# rotate form model towards where it moves
	if arah_gerak.length() > .3 and ((rotateOnFloorOnly and is_on_floor()) or (not rotateOnFloorOnly)):
		_lookAtDirection = Vector2(arah_gerak.z, arah_gerak.x).rotated(-rotation.y).normalized()
		# with smooth rotate simplificed by Konstantin Glubev replying NovemberDev
		_collider.rotation.y = lerp_angle(_collider.rotation.y, _lookAtDirection.angle(), delta * smoothRotateSpeed) if smoothCharRotate else _lookAtDirection.angle()
		# NOTE: immediately face towards the look at direction when dive whoosh Hat Kid
		_form.rotation.y = lerp_angle(_form.rotation.y, _lookAtDirection.angle(), delta * smoothRotateSpeed) if smoothCharRotate else _lookAtDirection.angle()
		_frontRef.rotation.y = lerp_angle(_frontRef.rotation.y, _lookAtDirection.angle(), delta * smoothRotateSpeed) if smoothCharRotate else _lookAtDirection.angle()
		pass
	
	if jalan != Vector2.ZERO:
		
		pass
	
	pass

func dive_now(handoverArahGerak:Vector3):
	var dive_towards:Vector3
	if not _startDiving:
		dive_towards.x = DIVE_SPEED * handoverArahGerak.x
		dive_towards.z = DIVE_SPEED * handoverArahGerak.z
		_dive_towards = dive_towards
		
		_startDiving = true
		pass
	else:
		return
	
#	while _startDiving:
#		dive_towards.x = DIVE_SPEED * handoverArahGerak.x
#		dive_towards.z = DIVE_SPEED * handoverArahGerak.z
##		_velocity = move_and_slide(_velocity + dive_towards, Vector3.UP)
#		_velocity.x = dive_towards.x
#		_velocity.z = dive_towards.z
#
#		if is_on_floor():
#			_startDiving = false
#		pass
#	pass

# Artindi's coyote time measurement
func coyoteTime():
	if shouldCoyoteJump and not _sparseCoyoteTimed:
		_sparseCoyoteTimed = true
		yield(get_tree().create_timer(howLongCoyoteTime), "timeout")
#		print('Coyote timed')
		shouldCoyoteJump = false
	pass

func _input(event):
	
	pass


func _on_SpringCamArm_on_camCurrent(value):
#	current = value
	set_current(value)
	pass # Replace with function body.
