extends Spatial

onready var shallMove = true
onready var cameraAimMode = false
onready var sensitivity = .25
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# https://docs.godotengine.org/en/latest/tutorials/inputs/input_examples.html#mouse-events
# https://www.reddit.com/r/godot/comments/bd2q87/how_to_make_a_camera_follow_the_player/

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if shallMove and event.pressed:
			shallMove = false
			print('PREEEEEEEEEEEEES')
			pass
		elif !shallMove and !event.pressed:
			shallMove = true
			pass
		pass
	
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if !event.pressed:
			if !cameraAimMode:
				cameraAimMode = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				cameraAimMode = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pass
		pass
	
	if event is InputEventMouseMotion:
		
		var movement = event.relative
		if shallMove and cameraAimMode:
			
			if $NonVRCamera.rotation.x <=0:
				rotation.x -= (deg2rad(movement.y) * sensitivity)
			rotation.y -= (deg2rad(movement.x) * sensitivity)
			
			if rotation.x >= 0:
				$NonVRCamera.rotation.x -= (deg2rad(movement.y) * sensitivity)
				pass
			pass
		pass
	rotation.x = clamp(rotation.x, deg2rad(-90), deg2rad(0))
	$NonVRCamera.rotation.x = clamp($NonVRCamera.rotation.x, deg2rad(0), deg2rad(45))
	pass
