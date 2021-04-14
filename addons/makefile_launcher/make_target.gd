tool
extends MarginContainer

signal target_selected(name, properties)

onready var exec_button = $Panel/HSplitContainer/HBoxContainer/ExecButton
onready var exec_confirm_button = $Panel/HSplitContainer/HBoxContainer/ExecConfirmButton
onready var loading_container = $Panel/HSplitContainer/HBoxContainer/Loading
onready var loading_icon = $Panel/HSplitContainer/HBoxContainer/Loading/LoadingIcon
onready var target_name_label = $Panel/HSplitContainer/HBoxContainer/PanelContainer/Name
onready var fields_container = $Panel/HSplitContainer/MarginContainer/FieldsAndTools/Fields
onready var clear_button = $Panel/HSplitContainer/MarginContainer/FieldsAndTools/ClearButton
onready var tween = $Tween

var target_name
var fields_line_edits = {}
var require_confirmation = false



func initialize(name, properties, confirmation_required):
	exec_button.visible = not confirmation_required
	exec_confirm_button.visible = confirmation_required
	loading_container.visible = false
	require_confirmation = confirmation_required
	
	target_name_label.text = name
	self.target_name = name
	
	for c in fields_container.get_children():
		fields_container.remove_child(c)
		c.queue_free()
	
	for f in properties:
		var label = Label.new()
		label.text = f
		var line_edit = LineEdit.new()
		line_edit.size_flags_horizontal = SIZE_EXPAND_FILL
		line_edit.size_flags_vertical = SIZE_SHRINK_CENTER
		fields_container.add_child(label)
		fields_container.add_child(line_edit)
		
		fields_line_edits[f] = line_edit
	clear_button.visible = properties.size() > 0


func set_loading(loading):
	exec_button.visible = not require_confirmation and not loading
	exec_confirm_button.visible = require_confirmation and not loading
	loading_container.visible = loading
	tween.remove_all()
	if loading:
		tween.interpolate_property(loading_icon, "rect_rotation", 0, -360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()


func _on_target_pressed():
	var properties = {}
	for n in fields_line_edits:
		var value = fields_line_edits[n].text
		properties[n] = value
	emit_signal("target_selected", target_name, properties)


func clear_properties():
	for line_edit in fields_line_edits.values():
		line_edit.text = ""
