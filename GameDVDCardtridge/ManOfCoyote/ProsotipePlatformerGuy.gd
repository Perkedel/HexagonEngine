extends KinematicBody

var MOVE_SPEED = 12
const JUMP_FORCE = 100
const GRAVITY = 0.98
const MAX_FALL_SPEED = 30

const H_LOOK_SENS = 1.0
const V_LOOK_SENS = 1.0

onready var cam = $HoldRigKamera
onready var anim = $Graphics/AnimationPlayer

var y_velo = 0

# Artindi's Special Coyote Time
var shouldCoyoteJump = false
var jumpJustPressed = false
export var howLongCoyoteTime = .5
export var howLongStickyLoncatButton = .1

# JOELwindows7 Special Double Jump Signature
var extraJumpTokenInit = 1
var JumpTokenRightNow = 1
var shouldUseExtraJumpToken = false

func _ready():
	anim.get_animation("walk").set_loop(true)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS

func _physics_process(delta):
	var move_vec = Vector3()
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
	move_and_slide(move_vec, Vector3(0, 1, 0))
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	
	if Input.is_action_just_pressed("Loncat"):
		jumpJustPressed = true
		rememberJumpTime()
		if shouldCoyoteJump:
			just_jumped = true
			y_velo = JUMP_FORCE
			pass
		if shouldUseExtraJumpToken and JumpTokenRightNow > 0:
			just_jumped = true
			y_velo = JUMP_FORCE
			JumpTokenRightNow -= 1
			pass
		pass
	# edit grounde
	if grounded:
		shouldCoyoteJump = true
		shouldUseExtraJumpToken = false
		resetJumpToken()
		if jumpJustPressed:
			just_jumped = true
			y_velo = JUMP_FORCE
			# shouldUseExtraJumpToken = true
			pass
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

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

func coyoteTime():
	yield(get_tree().create_timer(howLongCoyoteTime), "timeout")
	#print('Coyote timed')
	shouldCoyoteJump = false
	shouldUseExtraJumpToken = true
	pass

func rememberJumpTime():
	yield(get_tree().create_timer(howLongStickyLoncatButton), "timeout")
	print('Remembered Jump Time')
	jumpJustPressed = false
	shouldUseExtraJumpToken = true
	pass

func resetJumpToken():
	JumpTokenRightNow = extraJumpTokenInit
	pass
