@tool
extends Button

# KoBeWi's Button context a.k.a. Action Icon
# https://github.com/KoBeWi/Godot-Action-Icon

enum {KEYBOARD, MOUSE, JOYPAD}
enum JoypadMode {ADAPTIVE, FORCE_KEYBOARD, FORCE_JOYPAD}
enum FitMode {NONE, MATCH_WIDTH, MATCH_HEIGHT}
enum JoypadModel {AUTO, XBOX, DUALSHOCK, JOY_CON}

@onready var actionIcon = $ContainsThese/ActionIcon
@onready var actionLabel = $ContainsThese/ActionLabel
@export var action_title: String = "": set = set_action_title
@export var action_name: String = "": set = set_action_name
@export var joypad_mode: JoypadMode: int = 0: set = set_joypad_mode
@export var joypad_model: JoypadModel: set = set_joypad_model
@export var favor_mouse: bool = true: set = set_favor_mouse
@export var fit_mode: FitMode: int = 1: set = set_fit_mode
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
#var cached_model:String setget ,get_cached_model
#var base_path: String setget ,get_base_path
#var use_joypad:bool setget ,get_use_joypad
#var pending_refresh: bool setget ,get_pending_refresh
var debug_deviceName = "Entahlah"
var own_pending_refresh: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func set_action_title(title:String) -> void:
	action_title = title
#	actionLabel.text = title
	$ContainsThese/ActionLabel.text = title

func set_action_name(name:String) -> void:
	action_name = name
#	actionIcon.action_name = actionIcon
	$ContainsThese/ActionIcon.action_name = name

func set_joypad_mode(mode:int) -> void:
	joypad_mode = mode
	actionIcon.joypad_mode = joypad_mode
	pass

func set_favor_mouse(favor: bool):
	favor_mouse = favor
	actionIcon.favor_mouse = favor_mouse

func set_joypad_model(model: int):
	joypad_model = model
	actionIcon.joypad_model = joypad_model

func set_fit_mode(mode: int):
	fit_mode = mode
	actionIcon.fit_mode = fit_mode

func get_keyboard(key: int) -> Texture2D:
	return actionIcon.get_keyboard(key)

func get_joypad_model(device: int) -> String:
	return actionIcon.get_joypad_model(device)
	pass

func get_joypad_model_raw(device: int) -> String:
	if not debug_deviceName.is_empty():
		return debug_deviceName
	
	var rawModel:= "Xbox"
	rawModel = Input.get_joy_name(device)
	
	debug_deviceName = rawModel
	return rawModel
	pass

func get_joypad(button: int, device: int) -> Texture2D:
	var model := get_joypad_model_raw(device)
	return actionIcon.get_joypad(button, device)
	pass

func get_joypad_axis(axis: int, value: float, device: int) -> Texture2D:
	var model := get_joypad_model_raw(device)
	return actionIcon.get_joypad_axis(axis, value, device)
	pass

func get_mouse(button: int) -> Texture2D:
	return actionIcon.get_mouse(button)

func get_image(type: int, image: String) -> Texture2D:
	return actionIcon.get_image(type, image)

func get_use_joypad():
	return actionIcon.use_joypad

#func get_cached_model():
#	return actionIcon.cached_model

# error nil
#func get_base_path():
#	return actionIcon.base_path if actionIcon.base_path != null else ""
#	if actionIcon.base_path != null:
#		return actionIcon.base_path
#		pass
#	else:
#		return ""

#func get_pending_refresh():
#	return actionIcon.pending_refresh

func _init() -> void:
	pass

func refresh():
	own_pending_refresh = true
	call_deferred("_refresh")
	pass

func _refresh():
	if not own_pending_refresh:
		return
	own_pending_refresh = false
	
	var keyboard := -1
	var mouse := -1
	var joypad := -1
	var joypad_axis := -1
	var joypad_axis_value: float
	var joypad_id: int
	
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey and keyboard == -1:
			keyboard = event.keycode
		elif event is InputEventMouseButton and mouse == -1:
			mouse = event.button_index
		elif event is InputEventJoypadButton and joypad == -1:
			joypad = event.button_index
			joypad_id = event.device
		elif event is InputEventJoypadMotion and joypad_axis == -1:
			joypad_axis = event.axis
			joypad_axis_value = event.axis_value
			joypad_id = event.device
	
	pass

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	
	if actionIcon.use_joypad and (event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion):
#		use_joypad = false
		refresh()
		pass
	elif not actionIcon.use_joypad and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
#		use_joypad = true
		refresh()
		pass
	
#	debug_deviceName = event.get_device()
	
	if event.is_action_pressed(action_name):
		flat = false
		pass
	elif event.is_action_released(action_name):
		flat = true
		pass
	pass

func on_joy_connection_changed(device: int, connected: bool):
	if connected:
#		cached_model = ""
		debug_deviceName = ""

func _on_Timer_timeout() -> void:
	pass # Replace with function body.
