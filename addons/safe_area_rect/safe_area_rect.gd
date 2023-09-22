@icon("./safe_area_rect.svg")
class_name SafeAreaRect
extends Control


@export
var ignore_anchor_left: bool = false
@export
var ignore_anchor_top: bool = false
@export
var ignore_anchor_right: bool = false
@export
var ignore_anchor_bottom: bool = false


var _initial_anchor_left: float
var _initial_anchor_top: float
var _initial_anchor_right: float
var _initial_anchor_bottom: float
var _last_window_size: Vector2i = Vector2i(0, 0)
var _last_safe_area: Rect2i = Rect2i(0, 0, 0, 0)


func _init() -> void:
	_initial_anchor_left = anchor_left
	_initial_anchor_top = anchor_top
	_initial_anchor_right = anchor_right
	_initial_anchor_bottom = anchor_bottom


func _ready() -> void:
	apply_safe_area_anchors(true)


func _process(_delta: float) -> void:
	apply_safe_area_anchors()


func apply_safe_area_anchors(force: bool = false) -> void:
	if not force and not is_fullscreen():
		return

	var window_size := get_window_size()
	var safe_area := get_safe_area()

	if not force and (window_size == _last_window_size and safe_area == _last_safe_area):
		return

	set_safe_area_anchors(
			self,
			NAN if ignore_anchor_left else _initial_anchor_left,
			NAN if ignore_anchor_top else _initial_anchor_top,
			NAN if ignore_anchor_right else _initial_anchor_right,
			NAN if ignore_anchor_bottom else _initial_anchor_bottom,
			Rect2i(
					get_window_position(),
					window_size,
			),
			safe_area,
	)

	_last_window_size = window_size
	_last_safe_area = safe_area


static func get_window_position() -> Vector2i:
	return DisplayServer.window_get_position()


static func get_window_size() -> Vector2i:
	return DisplayServer.window_get_size_with_decorations()


static func get_safe_area() -> Rect2i:
	return DisplayServer.get_display_safe_area()


static func is_fullscreen() -> bool:
	var window_mode := DisplayServer.window_get_mode()
	return (
			window_mode == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
			or window_mode == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			or window_mode == DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED
	)


static func set_safe_area_anchors(
		control: Control,
		initial_anchor_left: float,
		initial_anchor_top: float,
		initial_anchor_right: float,
		initial_anchor_bottom: float,
		window_rect: Rect2i = Rect2i(
				get_window_position(),
				get_window_size(),
		),
		safe_area: Rect2i = get_safe_area(),
) -> void:
	var window_size := window_rect.size

	if (
			window_size.x > safe_area.size.x
			or window_size.y > safe_area.size.y
	):
		var window_position := window_rect.position
		var window_end := window_position + window_size

		if not is_nan(initial_anchor_left):
			var new_anchor_left := absf(safe_area.position.x - window_position.x) / window_size.x
			control.anchor_left = maxf(new_anchor_left, initial_anchor_left)

		if not is_nan(initial_anchor_top):
			var new_anchor_top := absf(safe_area.position.y - window_position.y) / window_size.y
			control.anchor_top = maxf(new_anchor_top, initial_anchor_top)

		if not is_nan(initial_anchor_right):
			var new_anchor_right := 1 - (absf(safe_area.end.x - window_end.x) / window_size.x)
			control.anchor_right = minf(new_anchor_right, initial_anchor_right)

		if not is_nan(initial_anchor_bottom):
			var new_anchor_bottom := 1 - (absf(safe_area.end.y - window_end.y) / window_size.y)
			control.anchor_bottom = minf(new_anchor_bottom, initial_anchor_bottom)
