tool
extends HBoxContainer

"""
Frame container that handles frame resize, minimize/maximize and position
"""

const MAX_MAXIMIZED_RATIO: float = 0.65

export(int) var minimized_size: int = 25
export(int) var min_maximized_size: int = 70

enum Side {LEFT = -1, RIGHT = 1}

var frames: Array = []
var min_maximized: float
var dragger_active: bool = false
var minimized_ratio: float
var coverage: int
var single_non_minimized: bool = false


func _ready() -> void:
	for child in get_children():
		if child is Separator:
			continue
		frames.append(child)
	update_minimized_ratio()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		update_minimized_ratio()


func update_minimized_ratio() -> void:
	coverage = int(self.rect_size.x)
	for child in get_children():
		if child is Separator:
			coverage -= int(child.rect_size.x)
	coverage -= (get_child_count() - 1) * get_constant("separation")
	minimized_ratio = minimized_size / float(coverage)
	min_maximized = min_maximized_size / float(coverage)


func find_frame(index: int, dir: int) -> Control:
	var frame_index: int = index + dir
	var frame: Control = null
	while frame_index >= 0 and frame_index <= get_child_count() - 1:
		frame = get_child(frame_index)
		if not frame.minimized:
			break
		frame_index += 2 * dir
		frame = null
	return frame


func resize_frames(shrinking_frame: Control, growing_frame: Control) -> void:
	var just_minimized: bool = false
	if shrinking_frame.size_flags_stretch_ratio <= minimized_ratio:
		shrinking_frame.minimize()
		shrinking_frame.size_flags_stretch_ratio = minimized_ratio
		just_minimized = true
	var remaining: float = 1.0
	for frame in frames:
		if frame != growing_frame:
			remaining -= frame.size_flags_stretch_ratio
	growing_frame.size_flags_stretch_ratio = remaining
	if just_minimized:
		var num_minimized: int = 0
		var last_maximized: Control
		for frame in frames:
			if frame.minimized:
				num_minimized += 1
			else:
				last_maximized = frame
		if num_minimized == frames.size() - 1:
			single_non_minimized = true
			last_maximized.disable_minimize(true)
	elif single_non_minimized:
		for frame in frames:
			frame.disable_minimize(false)
		single_non_minimized = false


func _on_dragger_gui_input(event: InputEvent, dragger_name: String) -> void:
	var dragger_index: int = get_node(dragger_name).get_position_in_parent()
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		dragger_active = event.is_pressed()
	elif dragger_active and event is InputEventMouseMotion:
		var relative: float = event.relative.x
		var growing_frame: Control
		var shrinking_frame: Control
		if relative > 0.0:
			growing_frame = get_child(dragger_index - 1) as Control
			shrinking_frame = find_frame(dragger_index, Side.RIGHT)
		else:
			shrinking_frame = find_frame(dragger_index, Side.LEFT)
			growing_frame = get_child(dragger_index + 1) as Control
		if shrinking_frame and growing_frame:
			shrinking_frame.saved_maximized = 0.0
			if growing_frame.minimized:
				growing_frame.maximize()
			var fraction: float = abs(relative / float(coverage))
			shrinking_frame.size_flags_stretch_ratio -= fraction
			resize_frames(shrinking_frame, growing_frame)


func _on_frame_minimize(frame: Control) -> void:
	# When minimized, it's preferred to expand the frame to the right of
	#  the minimized frame
	var frame_index: int = frame.get_position_in_parent()
	var growing_frame = find_frame(frame_index + 1, Side.RIGHT)
	if not growing_frame:
		growing_frame = find_frame(frame_index - 1, Side.LEFT)
	frame.saved_maximized = frame.size_flags_stretch_ratio
	frame.size_flags_stretch_ratio = 0.0
	resize_frames(frame, growing_frame)


func _on_frame_maximize(frame: Control) -> void:
	frame.maximize()
	var frame_index: int = frame.get_position_in_parent()
	var shrinking_frame: Control = find_frame(frame_index + 1, Side.RIGHT)
	if not shrinking_frame:
		shrinking_frame = find_frame(frame_index - 1, Side.LEFT)
	var maximized_ratio: float = max(frame.saved_maximized, min_maximized)
	if shrinking_frame.size_flags_stretch_ratio > maximized_ratio:
		shrinking_frame.size_flags_stretch_ratio -= maximized_ratio - frame.size_flags_stretch_ratio
		resize_frames(shrinking_frame, frame)
	else:
		maximized_ratio = min(frame.saved_maximized, MAX_MAXIMIZED_RATIO)
		var available: float = 0.0
		for fr in frames:
			if not fr.minimized and not fr == frame:
				available += fr.size_flags_stretch_ratio
		var remaining: float = available - maximized_ratio + minimized_ratio
		for fr in frames:
			if frame == fr:
				fr.size_flags_stretch_ratio = maximized_ratio
			elif not fr.minimized:
				fr.size_flags_stretch_ratio = fr.size_flags_stretch_ratio * available * remaining


