extends Camera2D

@export_range(0, 1) var zoomSens = 0.1
@export_range(0, 10) var panSens = 1

@export var keyboardPanSpeed = 5

var isPaused = false

## Pauses the Panning and Zooming of the Camera
func pausePanzoom():
	isPaused = true

## Continues the Panning and Zooming of the Camera
func continuePanzoom():
	isPaused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var modifier = 1
	if Input.is_key_pressed(KEY_CTRL):
		modifier = 3

	if Input.is_action_pressed("ui_down"):
		position.y += keyboardPanSpeed * modifier
	if Input.is_action_pressed("ui_up"):
		position.y -= keyboardPanSpeed * modifier
	if Input.is_action_pressed("ui_right"):
		position.x += keyboardPanSpeed * modifier
	if Input.is_action_pressed("ui_left"):
		position.x -= keyboardPanSpeed * modifier


func _input(event):

	if isPaused:
		return

	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			position -= event.relative * panSens / zoom

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoomSens, zoomSens)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoomSens, zoomSens)


