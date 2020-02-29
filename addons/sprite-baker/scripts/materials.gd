tool
extends VBoxContainer

"""
Materials used for the current selected model can be edited in this
panel. For each mesh surface present in the model, there will be one
material slot. Material slots (MaterialProps.tscn) offer a number of
options to configure materials. Currently only SpatialMaterial is
supported.

Whenever a material in a material slot is changed, it is notified to
all nodes present in the 'SpriteBaker.Materials' group as follows:

materials_group_node.update_surface_material(mesh_nodepath, surface_index, material)

'mesh_nodepath' is the path to the mesh node relative to the active model.
'surface_index' is the index of the surface within the indicated mesh
'material' is the new material for the surface

"""

const Tools: Script = preload("tools.gd")

const NoOutlineIcon: Texture = preload("res://addons/sprite-baker/resources/icons/outline_no.svg")
const OutlineIcon: Texture = preload("res://addons/sprite-baker/resources/icons/outline.svg")
const PixelOutlineIcon: Texture = preload("res://addons/sprite-baker/resources/icons/outline_pixel.svg")

enum OutlineState {NO_OL, OL, PIXEL_OL}

export(PackedScene) var material_param_scn: PackedScene
export(NodePath) var materials_list_path: NodePath
export(NodePath) var outline_path: NodePath
export(NodePath) var outline_color_path: NodePath
export(NodePath) var pixel_box_path: NodePath

onready var materials_list: BoxContainer = get_node(materials_list_path)
onready var outline: Button = get_node(outline_path)
onready var outline_color: ColorPickerButton = get_node(outline_color_path)
onready var pixel_box: BoxContainer = get_node(pixel_box_path)

var model: Spatial
var mat_dict: Dictionary
var copied_material: Material
var outline_state: int = OutlineState.NO_OL


func update_model(model_: Spatial) -> void: # SpriteBaker.Model group function
	yield(get_tree(), "idle_frame") # Wait for all nodes to update the model
	model = model_
	Tools.clear_node(materials_list)
	mat_dict = {}
	var meshes: Array = Tools.find_nodes_by_type("MeshInstance", model)
	var surf_names: Dictionary = {}
	for im in range(meshes.size()):
		var mesh_inst: MeshInstance = meshes[im]
		var mesh: ArrayMesh = mesh_inst.mesh
		for isurf in range(mesh.get_surface_count()):
			var surf_name: String = mesh.surface_get_name(isurf)
			if surf_name == "":
				surf_name = mesh_inst.name + String(isurf)
			var surf_id: String = "%s:%d" % [String(model.get_path_to(mesh_inst)), isurf]
			var mat: Material = mesh.surface_get_material(isurf)
			mat_dict[surf_id] = mat
			if surf_names.has(surf_name):
				surf_names[surf_name].append(surf_id)
			else:
				surf_names[surf_name] = [surf_id]
	var list: Array = []
	var mat_names: Dictionary = {}
	for sname in surf_names:
		if surf_names[sname].size() == 1:
			list.append(sname)
			mat_names[sname] = surf_names[sname][0]
		else:
			var i: int = 0
			for sid in surf_names[sname]:
				var nm: String = sname + String(i)
				list.append(nm)
				mat_names[nm] = sid
	list.sort()
	var nmat: int = list.size()
	var imat: int = 0
	for surf_name in list:
		var surf_id: String = mat_names[surf_name]
		var mat: Material = mat_dict[surf_id]
		var split: PoolStringArray = surf_id.split(":")
		var mat_props: Control = material_param_scn.instance()
		mat_props.init(surf_name, split[0], int(split[1]), mat.resource_path, mat.duplicate())
		var color: Color = Color.from_hsv(imat / float(nmat), 0.50, 0.75)
		materials_list.add_child(mat_props)
		mat_props.set_plain_color(color)
		assert(mat_props.connect("material_copied", self, "_on_mat_props_material_copied") == OK)
		assert(mat_props.connect("paste_material", self, "_on_mat_props_paste_material") == OK)
		imat += 1
	set_info(list.size())


func clear_model() -> void: # SpriteBaker.Model group function
	Tools.clear_node(materials_list)
	model = null
	mat_dict = {}
	set_info(0)


func update_surface_material(mesh_path: String, surf_index: int, mat: Material): # SpriteBaker.Materials group function
	var mesh_inst: MeshInstance = model.get_node(mesh_path)
	mesh_inst.set_surface_material(surf_index, mat)


func set_info(nmat: int) -> void:
	var info_label: Label
	for node in get_tree().get_nodes_in_group("SpriteBaker.Info"):
		if node.name == "ModelInfo":
			info_label = node
			break
	var info_txt: String = "Materials: " + String(nmat)
	info_label.text = Tools.replace_info(info_label.text, info_txt, 1)


func _on_mat_props_material_copied(mat: Material) -> void:
	copied_material = mat
	for child in materials_list.get_children():
		child.copied_material_available()


func _on_mat_props_paste_material(slot: Control, unique: bool) -> void:
	slot.paste_material(copied_material, unique)


func _on_Outline_pressed() -> void:
	if outline_state == OutlineState.NO_OL:
		outline_state = OutlineState.OL
		outline.icon = OutlineIcon
		outline.hint_tooltip = "Toggle outline: outline"
		outline_color.disabled = false
		pixel_box.hide()
	elif outline_state == OutlineState.OL:
		outline_state = OutlineState.PIXEL_OL
		outline.icon = PixelOutlineIcon
		outline.hint_tooltip = "Toggle outline: pixel outline"
		outline_color.disabled = false
		pixel_box.show()
		for node in get_tree().get_nodes_in_group("SpriteBaker.PostProcess"):
			node.post_process = true
	elif outline_state == OutlineState.PIXEL_OL:
		outline_state = OutlineState.NO_OL
		outline.icon = NoOutlineIcon
		outline.hint_tooltip = "Toggle outline: no outline"
		outline_color.disabled = true
		pixel_box.hide()
		for node in get_tree().get_nodes_in_group("SpriteBaker.PostProcess"):
			node.post_process = false


func _on_Blend_toggled(checked: bool) -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.PostProcess"):
		node.set_pp_blend(checked)


func _on_Depth_toggled(checked: bool) -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.PostProcess"):
		node.set_pp_use_depth(checked)


func _on_DepthValue_value_changed(value: float) -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.PostProcess"):
		node.set_pp_depth_cutoff(value)
