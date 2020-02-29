extends Object

const BYTE_PREFIX = [
	"B", "kB", "MB", "TB", "PB"
]


static func find_nodes_by_type(type: String, parent: Node) -> Array:
	var nodes: = Array()
	for child in parent.get_children():
		var child_nodes: Array = find_nodes_by_type(type, child)
		for n in child_nodes:
			nodes.append(n)
	if parent.get_class() == type:
		nodes.append(parent)
	return nodes


static func find_single_node_by_type(type: String, parent: Node) -> Node:
	var nodes: Array = find_nodes_by_type(type, parent)
	if nodes.size() == 0:
		#printerr("Node of type ", type, " not found in the scene")
		return null
	if nodes.size() > 1:
		printerr("Multiple nodes in the same scene not supported for class ", type)
	return nodes[0] as Node


static func format_int_with_commas(number: int) -> String:
	var n: String = String(number)
	var res: String = ""
	var l: int = n.length()
	for i in range(round((l - 1.0) / 3.0)):
		if i != 0:
			res = "," + res
		res = n.substr(l - 3 * (i + 1), 3) + res
	if l < 3:
		res = n
	elif l % 3 != 0:
		res = n.substr(0, l % 3) + "," + res
	return res


static func clear_node(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()


static func is_node_being_edited(node: Node) -> bool:
	if node.is_inside_tree():
		var edited_scene: Node = node.get_tree().edited_scene_root
		return Engine.is_editor_hint() && edited_scene && \
			(edited_scene.is_a_parent_of(node) || edited_scene == node)
	else:
		return false

static func get_addon_path(node: Node) -> String:
	"""
		Finds the path to the plugin by looking at the path of the node's script
	"""
	var script_path: String = node.get_script().resource_path
	var path = script_path.get_base_dir().trim_suffix("scripts")
	return path

static func int_to_bytestr(num: int) -> String:
	var order: int = int((String(num).length() - 1) / 3.0)
	var prefix: String = BYTE_PREFIX[order]
	if order < 1:
		return "%d %s" % [num, prefix]
	else:
		var reduced: float = num / pow(10.0, 3 * order)
		var decimal: int = int(round((reduced - int(reduced)) * 100.0))
		return "%d.%02d %s" % [int(reduced), decimal, prefix]

static func fit_text(text: String, width: int, font: Font) -> String:
	if text == "":
		return ""
	var text_width: float = font.get_string_size(text).x
	var length: int = text.length()
	if text_width > width:
		var nchars: int = int(ceil(width * length / text_width))
		var out_text: String = ".."
		for ichar in range(nchars, 0, -1):
			var txt: String = "%s..%s" % \
				[text.left(int(min(ichar,10))), text.right(length - ichar)]
			if font.get_string_size(txt).x <= width:
				if txt.length() >= length:
					txt = text
				out_text = txt
				break
		return out_text
	else:
		return text

static func replace_info(in_txt:String, message: String, pos: int) -> String:
	var split: PoolStringArray = in_txt.split("  |  ")
	if split.size() <= pos:
		split.resize(pos + 1)
	split[pos] = message
	var out_txt: String = split[0]
	for i in range(1, split.size()):
		out_txt += "  |  " + split[i]
	return out_txt
