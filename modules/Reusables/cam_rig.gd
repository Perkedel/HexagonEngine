extends Node3D
# pls yoink View from https://github.com/KenneyNL/Starter-Kit-3D-Platformer

@export_group("Properties")
@export var target: Node
@export var ownActive:bool = false

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120

@export_group('Keymap')
@export var cameraLeftKey:String = 'Kamera_Kiri'
@export var cameraRightKey:String = 'Kamera_Kanan'
@export var cameraDownKey:String = 'Kamera_Bawah'
@export var cameraUpKey:String = 'Kamera_Atas'
@export var jumpKey:String = 'Melompat'

@export_group('Controller')
@export var onePlayerOnly:bool = true
@export var expectedPlayer:int = 0

var camera_rotation:Vector3
var zoom = 10
var moveAxes:Array[float]=[0,0,0,0]
var inputer:Vector3

@onready var camera = $Camera3D

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	
	pass

func setOwnActivate(to:bool = true):
	ownActive = to
	pass

func assignCamera():
	pass

func assignTarget(with:Node):
	target = with
	pass

func _physics_process(delta):
	
	# Set position and rotation to targets
	if target:
		self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	if ownActive:
		input.y = Input.get_axis(cameraLeftKey, cameraRightKey)
		input.x = Input.get_axis(cameraUpKey, cameraDownKey)
#		input.x += 1 * delta
		pass
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	# Zooming
	if ownActive:
		zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
		zoom = clamp(zoom, zoom_maximum, zoom_minimum)
		pass

func _unhandled_input(event: InputEvent) -> void:
	
	pass
