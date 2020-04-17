extends KinematicBody2D

const SPEED = 350
var move_direction:Vector2 = Vector2.RIGHT
var aim_direction:Vector2 = Vector2.RIGHT
var aiming:bool = false

func _physics_process(delta):
	var move_input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).clamped(1) #just in case someone uses buttons - Joystick already returns clamped value
	
	if move_input != Vector2.ZERO: move_direction = move_input
	
	if aiming:
		var aim_input = Vector2(
			Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
			Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
		)
		if aim_input != Vector2.ZERO: aim_direction = aim_input
	else:
		aim_direction = move_direction
	
	$base.rotation = move_direction.angle()
	$cannon.rotation = aim_direction.angle()
	
	move_and_slide(move_input * SPEED)

func _on_aim_pressed(pressed):
	aiming = pressed
