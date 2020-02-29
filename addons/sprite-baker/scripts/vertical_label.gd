tool
extends Control

export(String) var text: String setget set_text, get_text

var label: Label


func _ready() -> void:
	label = Label.new()
	label.align = Label.ALIGN_RIGHT
	label.valign = Label.VALIGN_CENTER
	label.text = text
	label.rect_rotation = -90.0
	add_child(label)
	self.rect_min_size = Vector2(label.get_combined_minimum_size().y, 0.0)
	arrange_label()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		arrange_label()


func set_text(t: String) -> void:
	text = t
	if is_inside_tree():
		label.text = text

func get_text() -> String:
	return text


func arrange_label() -> void:
	label.rect_size = Vector2(self.rect_size.y, self.rect_size.x)
	label.rect_position = Vector2(0.0, self.rect_size.y)
