tool
extends ViewportContainer

const LOOKAROUND_SPEED: float = 0.01

export(NodePath) var scene3d_path: NodePath

onready var scene3d: Spatial = get_node(scene3d_path)

var rotate: bool = false
var rotx: float = 0.0
var roty: float = 0.0

var process_gui: bool = false
var mouse_pos: Vector2
var rot_factor: float = 1.0


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		if scene3d and scene3d.model:
			scene3d.fit_to_viewport()


func _gui_input(event: InputEvent) -> void:
	if !process_gui:
		return
	if event is InputEventMouseButton && \
		(event.button_index == BUTTON_MIDDLE || event.button_index == BUTTON_RIGHT):
		if event.is_pressed():
			rotate = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_pos = event.position
		else:
			rotate = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			warp_mouse(mouse_pos)
	elif rotate && event is InputEventMouseMotion:
		rotx += event.relative.x * LOOKAROUND_SPEED * rot_factor
		roty += event.relative.y * LOOKAROUND_SPEED * rot_factor
		for node in get_tree().get_nodes_in_group("SpriteBaker.Viewport"):
			node.rotate_model(rotx, roty)


func update_model(model: Spatial) -> void: # SpriteBaker.Model group function
	scene3d.set_model(model)
	scene3d.adjust_camera()
	rotx = 0.0
	roty = 0.0
	process_gui = true


func clear_model() -> void: # SpriteBaker.Model group function
	scene3d.set_model(null)
	process_gui = false


func rotate_model(rx: float, ry: float) -> void: # SpriteBaker.Viewport group function
	rotx = wrapf(rx, -PI, PI)
	roty = wrapf(ry, -PI, PI)
	scene3d.rotate_model(rotx, roty)


func set_root_motion_track(root_path: String, bone_id: int) -> void:  # SpriteBaker.Viewport group function
	if root_path == "":
		scene3d.clear_root_motion_track()
	else:
		scene3d.set_root_motion_track(root_path, bone_id)
