tool
extends MarginContainer

"""
A frame consisting of a title bar and a content panel. Can be minimized/maximized and
moved with respect to its position in its parent's children list.

The text in the title bar can be set with the title variable.

When adding content to the frame, it should be done under the MaxBox/ContentPanel/Content node
"""

signal minimize(frame)
signal maximize(frame)

const TITLE_SCROLL_SENSITIVITY: int = 5
const Tools: Script = preload("tools.gd")

export(String) var title: String = "(Frame title)" setget set_title, get_title
export(NodePath) var move_left_path: NodePath
export(NodePath) var move_right_path: NodePath
export(NodePath) var move_left_min_path: NodePath
export(NodePath) var move_right_min_path: NodePath
export(NodePath) var minimize_path: NodePath
export(NodePath) var title_box_path: NodePath
export(NodePath) var title_path: NodePath
export(NodePath) var title_min_path: NodePath
export(PackedScene) var preview_scn: PackedScene

onready var title_box: BoxContainer = get_node(title_box_path)

var minimized: bool = false
# warning-ignore:unused_class_variable
var saved_maximized: float
var title_shifted: bool = false
var dragging: bool = false


func _ready() -> void:
	set_process_input(false)
	set_title(title)
	if Tools.is_node_being_edited(self):
		return
	enable_move_buttons()
	connect_signals()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and title_shifted:
		var box_size: float = title_box.get_combined_minimum_size().x
		var max_size: float = title_box.get_parent().rect_size.x
		if box_size > max_size:
			title_box.margin_right = box_size - title_box.rect_position.x - max_size
			title_box.rect_size.x = box_size
			if title_box.margin_right < 0.0:
				title_box.rect_position.x -= title_box.margin_right
				title_box.margin_right = 0.0
		else:
			title_box.margin_right = 0.0
			title_box.rect_position.x = 0.0
			title_shifted = false


func _input(event: InputEvent) -> void:
	if dragging: # The frame that is being dragged
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
			if minimized:
				$MinBar.show()
			else:
				$MaxBox.show()
			yield(get_tree(), "idle_frame")
			set_process_input(false)
			dragging = false
	else: # The frame over which is being dragged
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
			yield(get_tree(), "idle_frame")
			$HighlightBox.hide()
			set_process_input(false)
		elif event is InputEventMouseMotion and not get_rect().has_point(event.position):
			$HighlightBox.hide()
			set_process_input(false)


func get_drag_data(position: Vector2) -> Object:
	if minimized or title_box.get_rect().has_point(position):
		var preview: Control = preview_scn.instance()
		preview.set_title(title)
		set_drag_preview(preview)
		set_process_input(true)
		$MinBar.hide()
		$MaxBox.hide()
		dragging = true
		return self
	return null


func can_drop_data(position: Vector2, dropped) -> bool:
	if dropped is MarginContainer and dropped.get_script() == self.get_script():
		if self != dropped:
			if position.x > self.rect_size.x * 0.5:
				$HighlightBox.show()
				$HighlightBox/Separator1.show()
				$HighlightBox/Separator2.hide()
			else:
				$HighlightBox.show()
				$HighlightBox/Separator1.hide()
				$HighlightBox/Separator2.show()
			set_process_input(true)
		return true
	else:
		return false


func drop_data(position: Vector2, dropped) -> void:
	if dropped == self:
		return
	move_frame(dropped, position.x < self.rect_size.x * 0.5)


func move_frame(frame: MarginContainer, to_left: bool):
	var parent: Control = get_parent()
	var frame_index: int = frame.get_position_in_parent()
	var self_index: int = get_position_in_parent()
	var separator: Separator
	if frame_index == 0:
		separator = parent.get_child(1)
	else:
		separator = parent.get_child(frame_index - 1)
	if to_left:
		if frame_index > self_index:
			parent.move_child(separator, self_index)
			parent.move_child(frame, self_index)
		else:
			parent.move_child(frame, self_index - 1)
			parent.move_child(separator, self_index - 1)
	else:
		if frame_index > self_index:
			parent.move_child(separator, self_index + 1)
			parent.move_child(frame, self_index + 2)
		else:
			parent.move_child(separator, self_index)
			parent.move_child(frame, self_index)
	enable_move_buttons()
	frame.enable_move_buttons()


func set_title(s: String) -> void:
	title = s
	if is_inside_tree():
		get_node(title_path).text = title
		get_node(title_min_path).text = title


func get_title() -> String:
	return title


func minimize() -> void:
	minimized = true
	$MaxBox.hide()
	$MinBar.show()


func maximize() -> void:
	minimized = false
	$MaxBox.show()
	$MinBar.hide()


func enable_move_buttons() -> void:
	var index: int = get_position_in_parent()
	var enable_left: bool = true if index == 0 else false
	var enable_right: bool = true if index == get_parent().get_child_count() - 1 else false
	get_node(move_left_path).disabled = enable_left
	get_node(move_right_path).disabled = enable_right
	get_node(move_left_min_path).disabled = enable_left
	get_node(move_right_min_path).disabled = enable_right


func connect_signals() -> void:
	assert(connect("minimize", get_parent(), "_on_frame_minimize") == OK)
	assert(connect("maximize", get_parent(), "_on_frame_maximize") == OK)


func disable_minimize(value: bool) -> void:
	get_node(minimize_path).disabled = value


func _on_Minimize_pressed() -> void:
	emit_signal("minimize", self)


func _on_Maximize_pressed() -> void:
	emit_signal("maximize", self)


func _on_TitleBar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == BUTTON_WHEEL_UP or
		event.button_index == BUTTON_WHEEL_DOWN):
		var box_size: float = title_box.get_combined_minimum_size().x
		var max_size: float = title_box.get_parent().rect_size.x
		if box_size > max_size:
			var min_displ: float = max_size - box_size
			var dir: = 1.0 if event.button_index == BUTTON_WHEEL_UP else -1.0
			var pos: float = title_box.rect_position.x + dir * TITLE_SCROLL_SENSITIVITY
			title_box.rect_position.x = max(min_displ, min(0.0, pos))
			title_shifted = true


func _on_MoveLeft_pressed() -> void:
	var self_index: int = get_position_in_parent()
	var frame: MarginContainer = get_parent().get_child(self_index - 2)
	move_frame(frame, false)


func _on_MoveRight_pressed() -> void:
	var self_index: int = get_position_in_parent()
	var frame: MarginContainer = get_parent().get_child(self_index + 2)
	move_frame(frame, true)
