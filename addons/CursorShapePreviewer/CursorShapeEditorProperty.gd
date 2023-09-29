@tool
extends EditorProperty

const CURSOR_SHAPE_HINT_STRING = [
	"Arrow", # 0
	"I-Beam",
	"Pointing Hand",
	"Cross",
	"Wait",
	"Busy",
	"Drag",
	"Can Drop",
	"Forbidden",
	"Vertical Resize",
	"Horizontal Resize",
	"Secondary Diagonal Resize",
	"Main Diagonal Resize",
	"Move",
	"Vertical Split",
	"Horizontal Split",
	"Help" # 16
]

var current_mouse_over := 0

var btn : OptionButton
var popup : PopupMenu
var cursor_preview : Control


func _init():
	btn = OptionButton.new()
	btn.fit_to_longest_item = false
	btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	for hint_string in CURSOR_SHAPE_HINT_STRING:
		btn.add_item(hint_string)
	
	popup = btn.get_popup()
	
	cursor_preview = Control.new()
	cursor_preview.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cursor_preview.mouse_filter = Control.MOUSE_FILTER_PASS
	popup.add_child(cursor_preview)
	
	btn.item_selected.connect(_btn_item_selected)
	popup.window_input.connect(_popup_gui_input)
	add_child(btn)
	add_focusable(btn)


func _update_property():
	current_mouse_over = get_edited_object().get("mouse_default_cursor_shape")
	btn.selected = current_mouse_over


func _btn_item_selected(idx : int):
	emit_changed("mouse_default_cursor_shape", idx)


func _popup_gui_input(event : InputEvent):
	if event is InputEventMouseMotion:
		var mouse_over = popup.get_focused_item()
		if mouse_over >= 0 and mouse_over != current_mouse_over:
			current_mouse_over = mouse_over
			cursor_preview.mouse_default_cursor_shape = mouse_over
