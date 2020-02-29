tool
extends VBoxContainer

const Tools: Script = preload("tools.gd")

const VIEWS: Array = [
	["Front", Vector2(0.0, 0.0)],
	["Rear", Vector2(PI, 0.0)],
	["Right", Vector2(-0.5 * PI, 0.0)],
	["Left", Vector2(0.5 * PI, 0.0)],
	["Top", Vector2(PI, -PI * 0.5)],
]

export(NodePath) var orientation_path: NodePath
export(NodePath) var bake_path: NodePath
export(NodePath) var fps_path: NodePath
export(NodePath) var anim_tree_path: NodePath

onready var anim_tree: Tree = get_node(anim_tree_path)

var or_menu: PopupMenu
var selected_anims: bool = false
var selected_ors: bool = true


func _ready() -> void:
	if Tools.is_node_being_edited(self):
		return
	or_menu = get_node(orientation_path).get_popup()
	or_menu.hide_on_checkable_item_selection = false
	assert(or_menu.connect("index_pressed", self, "_on_or_menu_index_pressed") == OK)


func enable_bake() -> void:
	var enable: bool = selected_anims and selected_ors
	get_node(bake_path).disabled = not enable
	get_node(fps_path).editable = enable


func _on_or_menu_index_pressed(index: int) -> void:
	or_menu.toggle_item_checked(index)
	if or_menu.is_item_checked(index):
		selected_ors = true
		enable_bake()
	else:
		var selected: bool = false
		for i in or_menu.get_item_count():
			if or_menu.is_item_checked(i):
				selected = true
				break
		if not selected:
			selected_ors = false
			enable_bake()


func _on_AnimationsTree_selected_animations(selected: bool) -> void:
	selected_anims = selected
	enable_bake()


func _on_Bake_pressed() -> void:
	var anim_data: Dictionary = anim_tree.get_selected_data()
	var views: Array = []
	for i in or_menu.get_item_count():
		if or_menu.is_item_checked(i):
			views.append(VIEWS[i])
	var data: Dictionary
	for node in get_tree().get_nodes_in_group("SpriteBaker.BakeOptions"):
		data = node.bake_options_data()
	data["animations"] = anim_data
	data["views"] = views
	for node in get_tree().get_nodes_in_group("SpriteBaker.Bake"):
		node.bake(data)
