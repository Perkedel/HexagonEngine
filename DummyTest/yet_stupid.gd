extends CharacterBody3D

# Godot provided the template!
# pls yoink View from https://github.com/KenneyNL/Starter-Kit-3D-Platformer

@export_group('Properties')
@export var HP:float = 100
@export var SPEED:float = 250.0
@export var JUMP_VELOCITY:float = 4.5
var currentHP:float = HP
var currentSpeed:float = SPEED
var currentJumpVelocity:float = 4.5

@export_group('Camera')
@export var currentCameraRig:Node

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var init_pos:Vector3 = position # checkpoint position

@export_group('Jump')
@export var extraJumpTokens:int = 1
@export var offFloorJumpPenalty:bool = true
@export var disableJump:bool = false
@export var jumpButtonBufferTime:float = .5
var currentJumpTokens:int = extraJumpTokens
var jumpedAlready:bool = false
var jumpBufferTimer:float = .5

@export_group('Falling')
@export var fallLimit:bool = true
@export var fallLimitInY:float = -10
@export var fallHPPenalty:bool = false
@export var fallHPDecrease:float = 5
@export var coyoteTimeCompensateIn:float = .5 #second
var coyoteTimer:float = .5

@export_group('Keymap')
@export var moveLeftKey:String = 'Jalan_Kiri'
@export var moveRightKey:String = 'Jalan_Kanan'
@export var moveBackKey:String = 'Jalan_Belakang'
@export var moveFrontKey:String = 'Jalan_Depan'
@export var jumpKey:String = 'Melompat'

@export_group('Controller')
@export var onePlayerOnly:bool = true
@export var expectedPlayer:int = 0

var ownActive:bool = false
var rotation_direction:float
var direction:Vector3
var moveAxes:Array[float]=[0,0,0,0]
var inputer:Vector3

func teleportToInit():
	position = init_pos
	pass

func setOwnActivate(to:bool):
	ownActive = to
	pass

func respawn():
	teleportToInit()
	pass

func damage(howMuch:float):
	HP -= howMuch
	pass

func heal(howMuch:float):
	HP += howMuch
	pass

func pushJump():
	velocity.y = currentJumpVelocity
	jumpedAlready = true
	pass

func manageJump():
	if (is_on_floor() or coyoteTimer > 0 or not offFloorJumpPenalty) and not jumpedAlready:
		pushJump()
		pass
	else:
		if currentJumpTokens > 0:
			pushJump()
			currentJumpTokens -= 1
			pass
	pass

func assignCamera(withMe:Node):
	currentCameraRig = withMe
	pass

func meMove(axes:Vector2 = Vector2.ZERO):
#	print('moveing ')
	direction = (transform.basis * Vector3(axes.x, 0, axes.y)).normalized()
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if coyoteTimer > 0:
			coyoteTimer -= delta
	else:
		currentJumpTokens = extraJumpTokens
		jumpedAlready = false
		coyoteTimer = coyoteTimeCompensateIn
	
	# Rotation
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
		pass
		
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	# Handle Jump.
	if ownActive:
	#	if Input.is_action_just_pressed(jumpKey) and is_on_floor():
		if Input.is_action_just_pressed(jumpKey):
			if not disableJump:
		#		if currentJumpTokens > 0:
		#			if is_on_floor():
		#				velocity.y = currentJumpVelocity
		#				jumpedAlready = true
		#			else:
		#				if (not offFloorJumpPenalty) or (offFloorJumpPenalty and (currentJumpTokens - 1 > 0 and not jumpedAlready) or jumpedAlready):
		#					velocity.y = currentJumpVelocity
		#					jumpedAlready = true
		#				pass
		#			currentJumpTokens -= 1
#				if (is_on_floor() or coyoteTimer > 0 or not offFloorJumpPenalty) and not jumpedAlready:
#					pushJump()
#					pass
#				else:
#					if currentJumpTokens > 0:
#						pushJump()
#						currentJumpTokens -= 1
#						pass
				pass
			pass
	pass
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir :Vector2= Input.get_vector(moveLeftKey, moveRightKey, moveFrontKey, moveBackKey)
	if ownActive:
#		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		pass
	if direction:
		velocity.x = direction.x * currentSpeed * delta
		velocity.z = direction.z * currentSpeed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)
	
	move_and_slide()
	
	if fallLimit:
		if position.y < fallLimitInY:
			respawn()
			if fallHPPenalty:
				damage(fallHPDecrease)
			pass
		pass

func _unhandled_input(event: InputEvent) -> void:
	if ((event.device != expectedPlayer) and onePlayerOnly) or event is InputEventKey:
		return
#	var input_dir :Vector2= Input.get_vector(moveLeftKey, moveRightKey, moveFrontKey, moveBackKey)
#	print('eeeeeeeeeeeeeeee')
#	direction = (transform.basis * Vector3(1, 0, 1)).normalized()
	var ub:Array[float] = [0,0,0,0]
	if ownActive:
		if event.is_action(moveFrontKey):
			moveAxes[2] = event.get_action_strength(moveFrontKey)
			pass
		if event.is_action(moveLeftKey):
			moveAxes[0] = event.get_action_strength(moveLeftKey)
			pass
		if event.is_action(moveRightKey):
			moveAxes[1] = event.get_action_strength(moveRightKey)
			pass
		if event.is_action(moveBackKey):
			moveAxes[3] = event.get_action_strength(moveBackKey)
			pass
		if event.is_action_pressed('Melompat'):
			manageJump()
			pass
		inputer = Vector3.ZERO 
		inputer.x = -moveAxes[1]+moveAxes[0]
		inputer.z = moveAxes[2]-moveAxes[3]
		inputer = inputer.rotated(Vector3.UP,currentCameraRig.rotation.y-rotation.y+deg_to_rad(180) if currentCameraRig else Vector3.ZERO)
	else:
		inputer = Vector3.ZERO
		moveAxes = [0,0,0,0]
	
#	direction = (transform.basis * Vector3(-moveAxes[0]+moveAxes[1], 0, -moveAxes[2]+moveAxes[3]))
	direction = (transform.basis * inputer)
	pass
