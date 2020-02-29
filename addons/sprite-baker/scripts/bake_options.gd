tool
extends GridContainer

export(NodePath) var pixel_density_path: NodePath
export(NodePath) var margin_path: NodePath
export(NodePath) var bones_tree_path: NodePath

onready var pixel_density: SpinBox = get_node(pixel_density_path)
onready var margin: SpinBox = get_node(margin_path)
onready var bones_tree: Tree = get_node(bones_tree_path)


func bake_options_data() -> Dictionary: # SpriteBaker.BakeOptions group function
	var data: Dictionary = {
		"pixel_density": pixel_density.value,
		"margin": margin.value,
	}

	var selected: TreeItem = bones_tree.get_selected()
	if selected:
		var root_motion_data: Array = selected.get_metadata(0)
		var root_path: String = root_motion_data[0]
		var bone_id: int = root_motion_data[1]
		data["root_motion:path"] = root_path
		data["root_motion:bone_id"] = bone_id
	return data
