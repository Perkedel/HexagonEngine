extends CharacterBody3D

# Godot provided the template!

@export_subgroup('Properties')
@export var HP:float = 100
@export var SPEED:float = 5.0
@export var JUMP_VELOCITY:float = 4.5
var currentHP:float = HP
var currentSpeed:float = SPEED
var currentJumpVelocity:float = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var init_pos:Vector3 = position # checkpoint position

@export_subgroup('Jump')
@export var extraJumpTokens:int = 1
@export var offFloorJumpPenalty:bool = true
@export var disableJump:bool = false
var currentJumpTokens:int = extraJumpTokens
var jumpedAlready:bool = false

@export_subgroup('Falling')
@export var fallLimit:bool = true
@export var fallLimitInY:float = -10
@export var fallHPPenalty:bool = false
@export var fallHPDecrease:float = 5
@export var coyoteTimeCompensateIn:float = .5 #second
var coyoteTimer:float = .5

@export_subgroup('Keymap')
@export var moveLeftKey:String = 'Jalan_Kiri'
@export var moveRightKey:String = 'Jalan_Kanan'
@export var moveBackKey:String = 'Jalan_Belakang'
@export var moveFrontKey:String = 'Jalan_Depan'
@export var jumpKey:String = 'Melompat'

var ownActive:bool = true

func teleportToInit():
	position = init_pos
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
				if (is_on_floor() or coyoteTimer > 0 or not offFloorJumpPenalty) and not jumpedAlready:
					pushJump()
					pass
				else:
					if currentJumpTokens > 0:
						pushJump()
						currentJumpTokens -= 1
						pass
			pass
	pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(moveLeftKey, moveRightKey, moveFrontKey, moveBackKey)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if ownActive:
		if direction:
			velocity.x = direction.x * currentSpeed
			velocity.z = direction.z * currentSpeed
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
