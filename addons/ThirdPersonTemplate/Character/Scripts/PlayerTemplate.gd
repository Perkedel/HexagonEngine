extends CharacterBody3D

# Grabs the prebuilt AnimationTree 
@onready var PlayerAnimationTree = $AnimationTree.get_path()
@onready var animation_tree = get_node(PlayerAnimationTree)
@onready var playback = animation_tree.get("parameters/playback")

# Allows to pick your chracter's mesh from the inspector
@export_node_path("Node3D") var PlayerCharacterMesh: NodePath
@onready var player_mesh = get_node(PlayerCharacterMesh)

# Gamplay mechanics and Inspector tweakables
@export var gravity = 9.8
@export var jump_force = 9
@export var walk_speed = 1.3
@export var run_speed = 5.5
@export var dash_power = 12 # Controls roll and big attack speed boosts

# Animation node names
var roll_node_name = "Roll"
var idle_node_name = "Idle"
var walk_node_name = "Walk"
var run_node_name = "Run"
var jump_node_name = "Jump"
var attack1_node_name = "Attack1"
var attack2_node_name = "Attack2"
var bigattack_node_name = "BigAttack"
var rollattack_node_name = "RollAttack"

# Condition States
var is_attacking = bool()
var is_rolling = bool()
var is_walking = bool()
var is_running = bool()

# Physics values
var direction = Vector3()
var horizontal_velocity = Vector3()
var aim_turn = float()
var movement = Vector3()
var vertical_velocity = Vector3()
var movement_speed = int()
var angular_acceleration = int()
var acceleration = int()

func _ready(): # Camera based Rotation
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)

func _input(event): # All major mouse and button input events
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015 # animates player with mouse movement while aiming 
	
	if event.is_action_pressed("aim"): # Aim button triggers a strafe walk and camera mechanic
		direction = $Camroot/h.global_transform.basis.z

func sprint_and_roll():
## Dodge button input with dash and interruption to basic actions
	if Input.is_action_just_pressed("sprint"):
		if !roll_node_name in playback.get_current_node() and !jump_node_name in playback.get_current_node() and !bigattack_node_name in playback.get_current_node():
			$DashTimer.start()
		
	if Input.is_action_just_released("sprint") and !$DashTimer.is_stopped():
		$DashTimer.stop()
		playback.start(roll_node_name) #"start" not "travel" to speedy teleport to the roll!
		horizontal_velocity = direction * dash_power
		is_rolling = true
		

		
func attack1(): # If not doing other things, start attack1
	if (idle_node_name in playback.get_current_node() or walk_node_name in playback.get_current_node()) and is_on_floor():
		if Input.is_action_just_pressed("attack"):
			if (is_attacking == false):
				playback.travel(attack1_node_name)
				
func attack2(): # If attack1 is animating, combo into attack 2
	if attack1_node_name in playback.get_current_node(): # Big Attack if sprinting, adds a dash
		if Input.is_action_just_pressed("attack"):
			playback.travel(attack2_node_name)
			
func attack3(): # If attack2 is animating, combo into attack 3. This is a template.
	if attack1_node_name in playback.get_current_node(): 
		if Input.is_action_just_pressed("attack"):
			pass #no current animation, but add it's playback here!
	
func rollattack(): # If attack pressed while rolling, do a special attack afterwards.
	if roll_node_name in playback.get_current_node(): 
		if Input.is_action_just_pressed("attack"):
			playback.travel(rollattack_node_name) #change this animation for a different attack
			
func bigattack(): # If attack pressed while springing, do a special attack
	if run_node_name in playback.get_current_node(): # Big Attack if sprinting, adds a dash
		if Input.is_action_just_pressed("attack"):
			horizontal_velocity = direction * dash_power
			playback.travel(bigattack_node_name) #Add and Change this animation node for a different attack
	
func _physics_process(delta):
	rollattack()
	bigattack()
	attack1()
	attack2()
	attack3()
	sprint_and_roll()
	
	var on_floor = is_on_floor() # State control for is jumping/falling/landing
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	movement_speed = 0
	angular_acceleration = 10
	acceleration = 15

	# Gravity mechanics and prevent slope-sliding
	if not is_on_floor(): 
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	else: 
		#vertical_velocity = -get_floor_normal() * gravity / 3
		vertical_velocity = Vector3.DOWN * gravity / 10
	
	# Defining attack state: Add more attacks animations here as you add more!
	if (attack1_node_name in playback.get_current_node()) or (attack2_node_name in playback.get_current_node()) or (rollattack_node_name in playback.get_current_node()) or (bigattack_node_name in playback.get_current_node()): 
		is_attacking = true
	else: 
		is_attacking = false

# Giving BigAttack some Slide
	if bigattack_node_name in playback.get_current_node(): 
		acceleration = 3

	# Defining Roll state and limiting movment during rolls
	if roll_node_name in playback.get_current_node(): 
		is_rolling = true
		acceleration = 2
		angular_acceleration = 2
	else: 
		is_rolling = false
	
#	Jump input and Mechanics
	if Input.is_action_just_pressed("jump") and ((is_attacking != true) and (is_rolling != true)) and is_on_floor():
		vertical_velocity = Vector3.UP * jump_force
		
	# Movement input, state and mechanics. *Note: movement stops if attacking
	if (Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right")):
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		is_walking = true
		
	# Sprint input, dash state and movement speed
		if Input.is_action_pressed("sprint") and $DashTimer.is_stopped() and (is_walking == true ):
			movement_speed = run_speed
			is_running = true
		else: # Walk State and speed
			movement_speed = walk_speed
			is_running = false
	else: 
		is_walking = false
		is_running = false
	
	if Input.is_action_pressed("aim"):  # Aim/Strafe input and  mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, $Camroot/h.rotation.y, delta * angular_acceleration)

	else: # Normal turn movement mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
	
	# Movment mechanics with limitations during rolls/attacks
	if ((is_attacking == true) or (is_rolling == true)): 
		horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * .01 , acceleration * delta)
	else: # Movement mechanics without limitations 
		horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, acceleration * delta)
	
	# The Physics Sauce. Movement, gravity and velocity in a perfect dance.
	velocity.z = horizontal_velocity.z + vertical_velocity.z
	velocity.x = horizontal_velocity.x + vertical_velocity.x
	velocity.y = vertical_velocity.y
	
	move_and_slide()

	# ========= State machine controls =========
	# The booleans of the on_floor, is_walking etc, trigger the 
	# advanced conditions of the AnimationTree, controlling animation paths
	
	# on_floor manages jumps and falls
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsInAir"] = !on_floor
	# Moving and running respectively
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	# Attacks and roll don't use these boolean conditions, instead
	# they use "travel" or "start" to one-shot their animations.
	
	
