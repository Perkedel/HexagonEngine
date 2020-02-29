tool
extends VSplitContainer

signal animation_finished

const ROTATIONS: Dictionary = {
	"Front": Vector2(0.0, 0.0),
	"Rear": Vector2(PI, 0.0),
	"Right": Vector2(-0.5 * PI, 0.0),
	"Left": Vector2(0.5 * PI, 0.0),
	"Top": Vector2(PI, -PI * 0.5),
}
const Tools: Script = preload("tools.gd")

const PlayIcon: Texture = preload("res://addons/sprite-baker/resources/icons/play.svg")
const PauseIcon: Texture = preload("res://addons/sprite-baker/resources/icons/pause.svg")
const SpatialIcon: Texture = preload("res://addons/sprite-baker/resources/icons/spatial.svg")
const SkeletonIcon: Texture = preload("res://addons/sprite-baker/resources/icons/skeleton.svg")
const BoneIcon: Texture = preload("res://addons/sprite-baker/resources/icons/bone.svg")
const NodeIcon: Texture = preload("res://addons/sprite-baker/resources/icons/node.svg")

export(ButtonGroup) var view_buttons_group: ButtonGroup
export(NodePath) var rx_spin_path: NodePath
export(NodePath) var ry_spin_path: NodePath
export(NodePath) var loop_button_path: NodePath
export(NodePath) var play_button_path: NodePath
export(NodePath) var stop_button_path: NodePath
export(NodePath) var time_spin_path: NodePath
export(NodePath) var timeline_path: NodePath
export(NodePath) var bake_path: NodePath
export(NodePath) var pixel_density_path: NodePath
export(NodePath) var root_motion_dialog_path: NodePath
export(NodePath) var root_motion_clear_path: NodePath
export(NodePath) var root_motion_path: NodePath
export(NodePath) var bones_tree_path: NodePath

onready var rx_spin: SpinBox = get_node(rx_spin_path)
onready var ry_spin: SpinBox = get_node(ry_spin_path)
onready var loop_button: Button = get_node(loop_button_path)
onready var play_button: Button = get_node(play_button_path)
onready var stop_button: Button = get_node(stop_button_path)
onready var time_spin: SpinBox = get_node(time_spin_path)
onready var timeline: BoxContainer = get_node(timeline_path)
onready var bake: Button = get_node(bake_path)
onready var pixel_density: SpinBox = get_node(pixel_density_path)
onready var root_motion_dialog: ConfirmationDialog = get_node(root_motion_dialog_path)
onready var root_motion_clear: Button = get_node(root_motion_clear_path)
onready var root_motion: Button = get_node(root_motion_path)
onready var bones_tree: Tree = get_node(bones_tree_path)

var view_pressed: bool = false
var anim_name: String = ""
var anim_player: AnimationPlayer
var playing: bool = false
var looping: bool = false
var anim_length: float = 0.0
var time: float = 0.0
var fps: float = 0.0


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	time += delta
	var finished: bool = false
	if looping:
		time = fmod(time, anim_length)
	elif time >= anim_length:
		finished = true
		time = anim_length
	for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
		node.set_anim_time(time)
	timeline.set_time(time)
	if finished:
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.play(anim_name)
		time = 0.0
		emit_signal("animation_finished")


func update_model(model: Spatial) -> void: # SpriteBaker.Model group function
	anim_player = Tools.find_single_node_by_type("AnimationPlayer", model)
	set_bones_tree(model)
	for button in view_buttons_group.get_buttons():
		if button.name == "Front":
			button.pressed = true
			break


func clear_model() -> void: # SpriteBaker.Model group function
	anim_player = null


func rotate_model(rx: float, ry: float) -> void: # SpriteBaker.Viewport group function
	rx_spin.value = rad2deg(rx)
	ry_spin.value = rad2deg(ry)
	if not view_pressed:
		for button in view_buttons_group.get_buttons():
			button.pressed = false


func set_root_motion_track(_root_path: String, _bone_id: int) -> void:  # SpriteBaker.Viewport group function
	if anim_name != "":
		var aname: String = anim_name
		var p: bool = playing
		# Stopping the animation and reseting the skeleton position will avoid errors
		# when a root motion node is assigned
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.stop()
			node.play(aname)
			if not p:
				node.play(aname) # Pause the animation if it was paused


func set_loop(aname: String, loop: bool) -> void: # SpriteBaker.Animation group function
	if aname == anim_name:
		loop_button.pressed = loop
		looping = loop


func play(aname: String) -> void: # SpriteBaker.Animation group function
	if aname == anim_name:
		if playing:
			play_button.icon = PlayIcon
			set_physics_process(false)
		else:
			play_button.icon = PauseIcon
			set_physics_process(true)
		playing = not playing
	else:
		anim_name = aname
		var anim: Animation = anim_player.get_animation(aname)
		loop_button.disabled = false
		looping = anim.loop
		loop_button.pressed = looping
		play_button.disabled = false
		play_button.icon = PauseIcon
		stop_button.disabled = false
		playing = true
		anim_length = anim.length
		time_spin.max_value = anim_length
		timeline.set_timeline(anim_length)
		time = 0.0
		bake.disabled = false
		set_physics_process(true)


func stop() -> void: # SpriteBaker.Animation group function
	anim_name = ""
	loop_button.disabled = true
	play_button.disabled = true
	play_button.icon = PlayIcon
	stop_button.disabled = true
	playing = false
	time_spin.value = 0.0
	time = 0.0
	timeline.clear()
	bake.disabled = true
	set_physics_process(false)


func set_anim_time(time_: float) -> void: # SpriteBaker.Animation group function
	time_spin.value = time_


func set_key_frames(fps_: float) -> void: # SpriteBaker.Animation group function
	fps = fps_


func set_bones_tree(model: Spatial) -> void:
	bones_tree.clear()
	if not model:
		return
	var skeleton: Skeleton = Tools.find_single_node_by_type("Skeleton", model)
	if not skeleton:
		root_motion.disabled = true
		return
	root_motion.disabled = false
	var parent: Node = model
	var hierarchy: Array = []
	while parent != skeleton:
		for child in parent.get_children():
			if child.is_a_parent_of(skeleton) || child == skeleton:
				hierarchy.append(child)
				parent = child
				break
	var item: TreeItem = null
	var path: String = ""
	for node in hierarchy:
		item = bones_tree.create_item(item)
		var icon: Texture = null
		if node is Skeleton:
			icon = SkeletonIcon
		elif node is Spatial:
			icon = SpatialIcon
		else:
			icon = NodeIcon
		if path != "":
			path += "/"
		path += node.name
		item.set_cell_mode(0, TreeItem.CELL_MODE_CUSTOM)
		item.set_icon(0, icon)
		item.set_text(0, node.name)
		if node is Spatial:
			item.set_metadata(0, [path, -1])
		else:
			item.set_selectable(0, false)
	var bone_items: Dictionary = {}
	bone_items[-1] = item
	for ibone in skeleton.get_bone_count():
		add_bone_to_tree(bone_items, skeleton, ibone, path)


func add_bone_to_tree(dict: Dictionary, skeleton: Skeleton, ibone: int, path: String) -> void:
	if dict.has(ibone):
		return
	var parent_id: int = skeleton.get_bone_parent(ibone)
	if not dict.has(parent_id):
		add_bone_to_tree(dict, skeleton, parent_id, path)
	var parent: TreeItem = dict[parent_id]
	var item: TreeItem = bones_tree.create_item(parent)
	item.set_cell_mode(0, TreeItem.CELL_MODE_CUSTOM)
	item.set_icon(0, BoneIcon)
	item.set_text(0, skeleton.get_bone_name(ibone))
	item.set_metadata(0, [path, ibone])
	dict[ibone] = item


func select_root_motion() -> void:
	var selected: TreeItem = bones_tree.get_selected()
	if selected:
		root_motion.text = selected.get_text(0)
		root_motion.icon = selected.get_icon(0)
		root_motion_clear.disabled = false
		var data: Array = selected.get_metadata(0)
		var root_path: String = data[0]
		var bone_id: int = data[1]
		for node in get_tree().get_nodes_in_group("SpriteBaker.Viewport"):
			node.set_root_motion_track(root_path, bone_id)


func _on_view_pressed() -> void:
	var button: Button = view_buttons_group.get_pressed_button()
	view_pressed = true
	var rot: Vector2 = ROTATIONS[button.name]
	for node in get_tree().get_nodes_in_group("SpriteBaker.Viewport"):
		node.rotate_model(rot.x, rot.y)
	view_pressed = false


func _on_Loop_toggled(button_pressed: bool) -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
		node.set_loop(anim_name, button_pressed)


func _on_Play_pressed() -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
		node.play(anim_name)


func _on_Stop_pressed() -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
		node.stop()


func _on_Timeline_time_changed(t: float) -> void:
	time = t
	if not playing:
		for node in get_tree().get_nodes_in_group("SpriteBaker.Animation"):
			node.set_anim_time(time)


func _on_RootMotion_pressed() -> void:
	root_motion_dialog.popup_centered(Vector2(340, 500))


func _on_RootMotionClear_pressed() -> void:
	root_motion_clear.disabled = true
	root_motion.text = "Assign..."
	root_motion.icon = null
	for node in get_tree().get_nodes_in_group("SpriteBaker.Viewport"):
		node.set_root_motion_track("", 0)


func _on_BonesTree_item_activated() -> void:
	select_root_motion()
	root_motion_dialog.hide()


func _on_RootMotionDialog_confirmed() -> void:
	select_root_motion()


func _on_SpriteView_pixel_density_changed(value: float) -> void:
	pixel_density.value = value


func _on_Bake_pressed() -> void:
	var anim_data: Dictionary = {
		anim_name: get_frame_keys()
	}
	var button: Button = view_buttons_group.get_pressed_button()
	var views: Array = [[button.name, ROTATIONS[button.name]]] if button else [["custom-view", Vector2(deg2rad(rx_spin.value), deg2rad(ry_spin.value))]]
	var data: Dictionary
	for node in get_tree().get_nodes_in_group("SpriteBaker.BakeOptions"):
		data = node.bake_options_data()
	data["animations"] = anim_data
	data["views"] = views
	for node in get_tree().get_nodes_in_group("SpriteBaker.Bake"):
		node.bake(data)


func get_frame_keys() -> Array:
	var keys: Array = []
	var anim: Animation = anim_player.get_animation(anim_name)
	var nframes: int = int(round(anim.length * fps))
	for i in range(nframes):
		keys.append(i * anim.length / float(nframes))
	if not anim.loop:
		keys.append(anim.length)
	return keys
