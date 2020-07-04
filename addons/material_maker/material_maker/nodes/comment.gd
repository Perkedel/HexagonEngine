extends MMGraphNodeBase

onready var label = $VBox/Label
onready var editor = $VBox/TextEdit

func _draw() -> void:
	var icon = preload("res://material_maker/icons/edit.tres")
	draw_texture_rect(icon, Rect2(rect_size.x-68, 4, 16, 16), false)
	draw_rect(Rect2(rect_size.x-48, 4, 16, 16), generator.color)
	if !is_connected("gui_input", self, "_on_gui_input"):
		connect("gui_input", self, "_on_gui_input")

func set_generator(g) -> void:
	generator = g
	label.text = generator.text
	rect_size = generator.size
	title = generator.title
	set_color(generator.color)

func _on_resize_request(new_size) -> void:
	rect_size = new_size
	generator.size = new_size

func _on_Label_gui_input(ev) -> void:
	if ev is InputEventMouseButton and ev.doubleclick and ev.button_index == BUTTON_LEFT:
		editor.rect_min_size = label.rect_size + Vector2(0, rect_size.y - get_minimum_size().y)
		editor.text = label.text
		label.visible = false
		editor.visible = true
		editor.select_all()
		editor.grab_focus()

func _on_TextEdit_focus_exited() -> void:
	label.text = editor.text
	generator.text = editor.text
	label.visible = true
	editor.visible = false

func _on_gui_input(event) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if Rect2(rect_size.x-48, 4, 16, 16).has_point(event.position):
			$Popup/ColorPicker.color = generator.color
			$Popup/ColorPicker.connect("color_changed", self, "set_color")
			$Popup.rect_position = event.global_position
			$Popup.popup()
			accept_event()
		elif Rect2(rect_size.x-68, 4, 16, 16).has_point(event.position):
			var dialog = preload("res://material_maker/widgets/line_dialog.tscn").instance()
			dialog.set_value(generator.title)
			dialog.set_texts("Comment", "Enter the comment node title")
			add_child(dialog)
			dialog.connect("ok", self, "set_title")
			dialog.popup_centered()
			accept_event()

func set_color(c):
	generator.color = c
	var color = c
	color.a = 0.3
	get_stylebox("comment").bg_color = color
	get_parent().send_changed_signal()

func set_title(t):
	title = t
	generator.title = t
	get_parent().send_changed_signal()
