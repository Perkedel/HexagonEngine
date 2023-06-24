extends CharacterBody3D
class_name HeroicPlayer

var MOVE_SPEED:float = 12
const JUMP_FORCE:float = 30
const GRAVITY:float = 0.98
const MAX_FALL_SPEED:float = 30

const H_LOOK_SENS:float = 1.0
const V_LOOK_SENS:float = 1.0

@onready var cam = $HoldRigKamera
@onready var anim = $polycat/AnimationPlayer
@onready var jumpBufferMaxTime = $JumpBufferMaxTime

var y_velo:float = 0

# Artindi's Special Coyote Time
var shouldCoyoteJump:bool = false
var jumpJustPressed:bool = false
var haveToBufferWaitJump:bool = false
@export var disableCoyoteTime:bool = false # for challenge mode
@export var howLongCoyoteTime:float = .5
@export var howLongStickyLoncatButton:float = .1

# who was this guy's jump buffer?
@export var disableJumpBuffer:bool = false # for challenge mode
@export var howLongJumpBufferWaitGround:float = .5
# Jump Buffer wait is when you press jump before grounding & out of token.
# when that happen, event must wait for ground for certain time. if finally ground & token back
# jump, otherwise drop all jump event.
# pls sauce I forgot who was that Valet game!!!

# JOELwindows7 Special Double Jump Signature
@export var disableExtraJump:bool = false # for challenge mode
var extraJumpTokenInit = 1
var JumpTokenRightNow = 1
var shouldUseExtraJumpToken = false

# Mitch Makes things interact https://youtu.be/C_-faOyIuTQ
@export var interaction_parent : NodePath = self.get_path()

var interaction_target:Node
var is_riding : bool = false
var interaction_away = true

signal on_interact_changed(newInteractable) 

func _ready():
#	anim.get_animation("walk").set_loop(true)
	anim.get_animation("walk").set_loop_mode(Animation.LOOP_LINEAR)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS
	
#	if event is InputEventJoypadMotion:
#		if event.axis == JOY_ANALOG_RX:
#			cam.rotation_degrees.y -= event.axis_value * H_LOOK_SENS
#			pass
#		if event.axis == JOY_ANALOG_RY:
#			cam.rotation_degrees.x -= event.axis_value * V_LOOK_SENS
#			pass
#		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
#		pass
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if interaction_target != null:
				if (interaction_target.has_method("interaction_interact")):
					interaction_target.interaction_interact(self)
	
	if event is InputEventKey:
#		if event.pressed and event.button_index == KEY_E:
#			if (interaction_target.has_method("interaction_rideable")):
#				is_riding = !is_riding
#				interaction_target.interaction_rideable(self,is_riding)
		pass
	if Input.is_action_just_pressed("Valve_Interaksi"):
		if interaction_target != null:
			if (interaction_target.has_method("interaction_rideable")):
				if is_riding: 
					is_riding = false
				else:
					is_riding = true
				interaction_target.interaction_rideable(self,is_riding)
			if interaction_away:
				interaction_target = null
				emit_signal("on_interactable_changed", null)
#		if is_riding:
#			is_riding = false

func _physics_process(delta):
	var move_vec = Vector3()
	var just_jumped = false
	var grounded = is_on_floor()
	
	if not is_riding:
		if Input.is_action_pressed("Jalan_Depan"):
			move_vec.z -= 1
		if Input.is_action_pressed("Jalan_Belakang"):
			move_vec.z += 1
		if Input.is_action_pressed("Jalan_Kanan"):
			move_vec.x += 1
		if Input.is_action_pressed("Jalan_Kiri"):
			move_vec.x -= 1
		move_vec = move_vec.normalized()
		move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
		move_vec *= MOVE_SPEED
		move_vec.y = y_velo
		set_velocity(move_vec)
		set_up_direction(Vector3(0, 1, 0))
		move_and_slide()
		
		y_velo -= GRAVITY
		
		if Input.is_action_just_pressed("Melompat"):
			jumpJustPressed = true
			rememberJumpTime()
			if shouldCoyoteJump and not disableCoyoteTime:
				just_jumped = true
				y_velo = JUMP_FORCE
				pass
			if shouldUseExtraJumpToken :
				if JumpTokenRightNow > 0 and not disableExtraJump:
					just_jumped = true
					y_velo = JUMP_FORCE
					JumpTokenRightNow -= 1
					pass
				else:
					# jump token ran out, buffer wait!
					haveToBufferWaitJump = true if not disableJumpBuffer else false
					jumpBufferMaxTime.start(howLongJumpBufferWaitGround)
					pass
			pass
	else:
		if interaction_target:
			if interaction_target.has_method("setYLaunch"):
				interaction_target.setYLaunch(rotation.y)
		pass
	
	
	cam.rotation_degrees.x -= Input.get_action_strength("AnalogKanan_y-") - Input.get_action_strength("AnalogKanan_y") * V_LOOK_SENS
	rotation_degrees.y -= Input.get_action_strength("AnalogKanan_x") - Input.get_action_strength("AnalogKanan_x-") * H_LOOK_SENS
	cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	

	
	if Input.is_action_just_pressed("interaksi_Kiri"):
		if interaction_target != null:
			if (interaction_target.has_method("interaction_interact")):
				interaction_target.interaction_interact(self)
			if (interaction_target.has_method("interaction_rideable")):
				if is_riding: 
					is_riding = false
				else:
					is_riding = true
				interaction_target.interaction_rideable(self,is_riding)
			if interaction_away:
				interaction_target = null
				emit_signal("on_interactable_changed", null)
				
	# edit grounde
	if grounded:
		shouldCoyoteJump = true if not disableCoyoteTime else false
		shouldUseExtraJumpToken = false
		resetJumpToken()
		if jumpJustPressed or haveToBufferWaitJump:
			# now either jump press or there is active out of token jump buffer
			just_jumped = true
			y_velo = JUMP_FORCE
			# shouldUseExtraJumpToken = true
			pass
#		if haveToBufferWaitJump:
#			play_anim("jump")
		haveToBufferWaitJump = false
		jumpBufferMaxTime.stop()
		pass
	if !grounded:
		#shouldUseExtraJumpToken = true
		coyoteTime()
		pass
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	
#	if shouldUseExtraJumpToken:
#		print("Extra Jump mode")
#		if jumpJustPressed:
#			if JumpTokenRightNow > 0:
#				just_jumped = true
#				y_velo = JUMP_FORCE
#				JumpTokenRightNow -= 1
#				pass
#			pass
#		pass
#	else:
#		resetJumpToken()
#		pass
	
	if just_jumped:
		play_anim("jump")
	elif grounded:
		
		if move_vec.x == 0 and move_vec.z == 0:
			play_anim("idle")
		else:
			play_anim("walk")
		
		if haveToBufferWaitJump:
			play_anim("jump")

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

func coyoteTime():
	await get_tree().create_timer(howLongCoyoteTime).timeout
	#print('Coyote timed')
	shouldCoyoteJump = false
	shouldUseExtraJumpToken = true
	pass

func rememberJumpTime():
	await get_tree().create_timer(howLongStickyLoncatButton).timeout
#	print('Remembered Jump Time')
	jumpJustPressed = false
	shouldUseExtraJumpToken = true
	pass

func resetJumpToken():
	JumpTokenRightNow = extraJumpTokenInit
	pass

# https://youtu.be/C_-faOyIuTQ
# Mitch Interaction system
func _on_Handteract_body_exited(body):
	interaction_away = true
	if (body == interaction_target) and not is_riding:
		interaction_target = null
		emit_signal("on_interactable_changed", null)
	pass # Replace with function body.

func _on_Handteract_body_entered(body):
	interaction_away = false
	if not is_riding:
		var canInteract := false
		
		# GDScript lacks the concept of interfaces, so we can't check whether the body implements an interface
		# Instead, we'll see if it has the methods we need
		if (body.has_method("interaction_can_interact")):
			# Interactables tell us whether we're allowed to interact with them.
			canInteract = body.interaction_can_interact(get_node(interaction_parent))
		
		if not canInteract:
			return
		
		interaction_target = body
		emit_signal("on_interactable_changed", interaction_target)
		
	pass # Replace with function body.


func _on_Handteract_area_entered(area):
	interaction_away = false
	if not is_riding:
		var canInteract := false
		
		# GDScript lacks the concept of interfaces, so we can't check whether the body implements an interface
		# Instead, we'll see if it has the methods we need
		if (area.has_method("interaction_can_interact")):
			# Interactables tell us whether we're allowed to interact with them.
			canInteract = area.interaction_can_interact(get_node(interaction_parent))
		
		if not canInteract:
			return
		
		interaction_target = area
		emit_signal("on_interactable_changed", interaction_target)
	pass # Replace with function body.


func _on_Handteract_area_exited(area):
	interaction_away = true
	if (area == interaction_target) and not is_riding:
		interaction_target = null
		emit_signal("on_interactable_changed", null)
	pass # Replace with function body.


func _on_jump_buffer_max_time_timeout() -> void:
	# when jump buffer times out, drop all jump
	haveToBufferWaitJump = false
	pass # Replace with function body.
