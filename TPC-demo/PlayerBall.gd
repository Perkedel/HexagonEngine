extends RigidBody3D

@export var speed = 10

@onready var camera : ThirdPersonCamera = $ThirdPersonCamera


func _physics_process(_delta):
	if Input.is_action_pressed("Jalan_Depan") :
		var dir = camera.get_front_direction()
		apply_central_force(dir * speed)
	if Input.is_action_pressed("Jalan_Belakang") :
		var dir = camera.get_back_direction()
		apply_central_force(dir * speed)
	if Input.is_action_pressed("Jalan_Kiri") :
		var dir = camera.get_left_direction()
		apply_central_force(dir * speed)
	if Input.is_action_pressed("Jalan_Kiri") :
		var dir = camera.get_right_direction()
		apply_central_force(dir * speed)


func _unhandled_input(event):
	if event.is_action_pressed("toggle_mouse_mode") :
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			camera.mouse_follow = false
		else :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			camera.mouse_follow = true
