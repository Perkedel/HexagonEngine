tool
extends "view_3d.gd"

signal pixel_density_changed(value)

const MAX_PIXELS: int = 3840
const Tools: Script = preload("tools.gd")

var res_x: int = 1
var res_y: int = 1

var pixel_dens: float = 32.0


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		self.rect_pivot_offset = self.rect_size * 0.5


func update_model(model: Spatial) -> void: # SpriteBaker.Model group function
	scene3d.set_model(model)
	set_resolution()
	scene3d.adjust_camera()
	rotx = 0.0
	roty = 0.0
	process_gui = true


func set_resolution() -> void:
	var aabb: AABB = scene3d.aabb
	res_x = int(ceil(aabb.size.x * pixel_dens))
	res_y = int(ceil(aabb.size.y * pixel_dens))
	if res_x > MAX_PIXELS || res_y > MAX_PIXELS:
		if res_x > res_y:
			res_y = int(ceil(res_y * MAX_PIXELS / float(res_x)))
			res_x = MAX_PIXELS
		else:
			res_x = int(ceil(res_x * MAX_PIXELS / float(res_y)))
			res_y = MAX_PIXELS
		pixel_dens = int(res_x / aabb.size.x)
		emit_signal("pixel_density_changed", pixel_dens)
	fit_viewport()
	scene3d.set_pp_pixel_size(1.0 / float(res_x), 1.0 / float(res_y))
	set_info()


func fit_viewport() -> void:
	var pratio: float = get_parent().rect_size.x / get_parent().rect_size.y
	var ratio: float = res_x / float(res_y)
	var scale: float
	if ratio > pratio:
		scale = get_parent().rect_size.x / res_x
		self.rect_size = Vector2(res_x, int(get_parent().rect_size.y / scale))
	else:
		scale = get_parent().rect_size.y / res_y
		self.rect_size = Vector2(int(get_parent().rect_size.x / scale), res_y)
	self.rect_scale = Vector2(scale, scale)
	self.rect_position = (get_parent().rect_size - self.rect_size) * 0.5
	rot_factor = scale


func set_info() -> void:
	var info_label: Label
	for node in get_tree().get_nodes_in_group("SpriteBaker.Info"):
		if node.name == "BakeInfo":
			info_label = node
			break
	var info_txt: String = "Sprite Size: %dx%d" % [res_x, res_y]
	info_label.text = Tools.replace_info(info_label.text, info_txt, 0)


func _on_Sprite_resized() -> void:
	if scene3d.model:
		fit_viewport()


func _on_PixelDensity_value_changed(value: float) -> void:
	pixel_dens = value
	set_resolution()
