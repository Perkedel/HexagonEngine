tool
extends Spatial

export(String) var skeleton_path = "../Armature"
export(String) var edit_bone = ""

func _process(delta):
	if not edit_bone == "" and not skeleton_path == "":
		var skeleton = get_node(skeleton_path)
		var bone = skeleton.find_bone(edit_bone)
		skeleton.set_bone_pose(bone,get_transform())

func _ready():
	set_process(true)
