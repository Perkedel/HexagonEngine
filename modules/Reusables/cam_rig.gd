extends Node3D
# pls yoink View from https://github.com/KenneyNL/Starter-Kit-3D-Platformer (MIT License)

@export_group("Properties")
@export var target: Node
@export var ownActive:bool = false

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120
@export var mouse_sensitive:float = .25

@export_group('Keymap')
@export var cameraLeftKey:String = 'Kamera_Kiri'
@export var cameraRightKey:String = 'Kamera_Kanan'
@export var cameraDownKey:String = 'Kamera_Bawah'
@export var cameraUpKey:String = 'Kamera_Atas'
@export var cameraZoomInKey:String = 'Kamera_Perbesar'
@export var cameraZoomOutKey:String = 'Kamera_Perkecil'
@export var cameraMouseCaptureKey:String = 'Kamera_Tangkap_Tetikus'
@export var jumpKey:String = 'Melompat'

@export_group('Controller')
@export var onePlayerOnly:bool = true
@export var expectedPlayer:int = 0
@export var controllerZoomings:bool = true

var camera_rotation:Vector3
var zoom = 10
var moveAxes:Array[float]=[0,0,0,0]
var zoomAxes:Array[float]=[0,0]
var inputer:Vector3
var zoomer:float = 0

@onready var camera = $Camera3D

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	
	pass

func setOwnActivate(to:bool = true):
	ownActive = to
	pass

func assignCamera(toPlayer:Node3D):
	target = toPlayer
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
	
	# Mouse Capture
	if ownActive:
		pass
	else:
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pass

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	if ownActive:
#		input.y = Input.get_axis(cameraLeftKey, cameraRightKey)
#		input.x = Input.get_axis(cameraUpKey, cameraDownKey)
#		input.x += 1 * delta
	#	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
		camera_rotation += inputer.limit_length(1.0) * rotation_speed * delta
#		print('Inputer ' + String.num(inputer.x) + ' ' + String.num(inputer.y) + ' ' + String.num(inputer.z) + ' ')
		pass
	
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	
	# Zooming
	if ownActive:
#		zoom += Input.get_axis(cameraZoomInKey,cameraZoomOutKey) * zoom_speed * delta
		zoom += zoomer * zoom_speed * delta
		zoom = clamp(zoom, zoom_maximum, zoom_minimum)
		pass

func _toggleMouseCapture():
	if ownActive:
		print('Mouse Capture attampt')
		match(Input.mouse_mode):
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				pass
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				pass
			_:
				pass
		pass
	else:
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pass
	pass

func _input(event: InputEvent) -> void:
	
	if ((event.device != expectedPlayer) and onePlayerOnly):
		return
	else:
		inputer = Vector3.ZERO
		zoomer = 0
		pass
		
	if ownActive:
		if event.is_action(cameraLeftKey):
			moveAxes[0] = event.get_action_strength(cameraLeftKey)
			pass
		if event.is_action(cameraRightKey):
			moveAxes[1] = event.get_action_strength(cameraRightKey)
			pass
		if event.is_action(cameraUpKey):
			moveAxes[2] = event.get_action_strength(cameraUpKey)
			pass
		if event.is_action(cameraDownKey):
			moveAxes[3] = event.get_action_strength(cameraDownKey)
			pass
		if event.is_action(cameraZoomInKey):
			zoomAxes[0] = event.get_action_strength(cameraZoomInKey)
			pass
		if event.is_action(cameraZoomOutKey):
			zoomAxes[1] = event.get_action_strength(cameraZoomOutKey)
			pass
		if event.is_action_pressed(cameraMouseCaptureKey):
			_toggleMouseCapture()
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
#				camera_rotation += Vector3(-event.relative.y*mouse_sensitive,-event.relative.x * mouse_sensitive,0).limit_length()
				camera_rotation += Vector3(-event.relative.y*mouse_sensitive,-event.relative.x * mouse_sensitive,0)
				
				pass
			if event.is_action(cameraZoomInKey+'.mouse'):
				zoomAxes[0] = event.get_action_strength(cameraZoomInKey)
				pass
			if event.is_action(cameraZoomOutKey+'.mouse'):
				zoomAxes[1] = event.get_action_strength(cameraZoomOutKey)
				pass
			pass
		inputer.x = -moveAxes[2]+moveAxes[3]
		inputer.y = moveAxes[0]-moveAxes[1]
		zoomer = zoomAxes[1]-zoomAxes[0]
		pass
	else:
		inputer = Vector3.ZERO
		zoomer = 0
		moveAxes = [0,0,0,0]
		pass
	
#	print('Camera ' + String.num(inputer.x) + ' ' + String.num(inputer.y) + ' / Zoom ' + String.num(zoomer) + '')
#	camera_rotation += inputer.limit_length() * rotation_speed
	pass
