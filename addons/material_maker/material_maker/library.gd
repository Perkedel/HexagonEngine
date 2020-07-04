extends VBoxContainer

var libraries = []

onready var tree : Tree = $Tree
onready var filter_line_edit : LineEdit = $HBoxContainer/Filter

func _ready() -> void:
	tree.set_column_expand(0, true)
	tree.set_column_expand(1, false)
	tree.set_column_min_width(1, 32)
	var lib_path = OS.get_executable_path().get_base_dir()+"/library/base.json"
	if !add_library(lib_path):
		add_library("res://material_maker/library/base.json")
	add_library("user://library/user.json")
	update_tree()

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.command and event.scancode == KEY_F:
		filter_line_edit.grab_focus()
		filter_line_edit.select_all()

func get_selected_item_name() -> String:
	return get_item_path(tree.get_selected())

func get_selected_item_doc_name() -> String:
	var item : TreeItem = tree.get_selected()
	if item == null:
		return ""
	var m : Dictionary = item.get_metadata(0)
	if m == null or !m.has("icon"):
		return ""
	return m.icon

func add_library(file_name : String, _filter : String = "") -> bool:
	var file = File.new()
	if file.open(file_name, File.READ) != OK:
		return false
	var lib = parse_json(file.get_as_text())
	file.close()
	if lib != null and lib.has("lib"):
		for m in lib.lib:
			m.library = file_name
		libraries.push_back(lib.lib)
		return true
	return false

func update_tree(filter : String = "") -> void:
	filter = filter.to_lower()
	tree.clear()
	tree.create_item()
	for l in libraries:
		for m in l:
			if filter == "" or m.tree_item.to_lower().find(filter) != -1:
				add_item(m, m.tree_item, get_preview_texture(m), null, filter != "")

func get_preview_texture(data : Dictionary) -> ImageTexture:
	if data.has("icon") and data.has("library"):
		var image_path = data.library.left(data.library.rfind("."))+"/"+data.icon+".png"
		var t : ImageTexture
		if image_path.left(6) == "res://":
			image_path = ProjectSettings.globalize_path(image_path)
		t = ImageTexture.new()
		var image : Image = Image.new()
		if image.load(image_path) == OK:
			t.create_from_image(image)
		else:
			print("Cannot load image "+image_path)
		return t
	return null

func add_item(item, item_name, item_icon = null, item_parent = null, force_expand = false) -> TreeItem:
	if item_parent == null:
		item.tree_item = item_name
		item_parent = tree.get_root()
	var slash_position = item_name.find("/")
	if slash_position == -1:
		var new_item : TreeItem = null
		var c = item_parent.get_children()
		while c != null:
			if c.get_text(0) == item_name:
				new_item = c
				break
			c = c.get_next()
		if new_item == null:
			new_item = tree.create_item(item_parent)
			new_item.set_text(0, item_name)
			new_item.collapsed = !force_expand
		if item_icon != null:
			new_item.set_icon(1, item_icon)
			new_item.set_icon_max_width(1, 32)
		if item.has("type") || item.has("nodes"):
			new_item.set_metadata(0, item)
		if item.has("collapsed"):
			new_item.collapsed = item.collapsed and !force_expand
		return new_item
	else:
		var prefix = item_name.left(slash_position)
		var suffix = item_name.right(slash_position+1)
		var new_parent = null
		var c = item_parent.get_children()
		while c != null:
			if c.get_text(0) == prefix:
				new_parent = c
				break
			c = c.get_next()
		if new_parent == null:
			new_parent = tree.create_item(item_parent)
			new_parent.collapsed = !force_expand
		new_parent.set_text(0, prefix)
		return add_item(item, suffix, item_icon, new_parent, force_expand)

func get_item_path(item : TreeItem) -> String:
	if item == null:
		return ""
	var item_path = item.get_text(0)
	var item_parent = item.get_parent()
	while item_parent != tree.get_root():
		item_path = item_parent.get_text(0)+"/"+item_path
		item_parent = item_parent.get_parent()
	return item_path

func get_icon_name(item_name : String) -> String:
	return item_name.to_lower().replace("/", "_").replace(" ", "_")

func serialize_library(array : Array, library_name : String = "", item : TreeItem = null, icon_dir : String = "") -> void:
	if item == null:
		item = tree.get_root()
	item = item.get_children()
	while item != null:
		if item.get_metadata(0) != null:
			var m : Dictionary = item.get_metadata(0)
			if library_name == "" or (m.has("library") and m.library == library_name):
				var copy : Dictionary = m.duplicate()
				copy.erase("library")
				copy.collapsed = item.collapsed
				if icon_dir != "" and m.has("icon"):
					var src_path = m.library.get_basename()+"/"+m.icon+".png"
					var icon_name : String = get_icon_name(get_item_path(item))
					var icon_path = icon_dir+"/"+icon_name+".png"
					var dir : Directory = Directory.new()
					dir.copy(src_path, icon_path)
					copy.icon = icon_name
				array.append(copy)
		elif !item.collapsed:
			var item_path = get_item_path(item)
			array.append({ tree_item=item_path, collapsed=false })
		serialize_library(array, library_name, item, icon_dir)
		item = item.get_next()

func save_library(library_name : String, _item : TreeItem = null) -> void:
	var array : Array = []
	serialize_library(array, library_name)
	var file = File.new()
	if file.open(library_name, File.WRITE) == OK:
		file.store_string(JSON.print({lib=array}, "\t", true))
		file.close()

func _on_Filter_text_changed(filter : String) -> void:
	update_tree(filter)

func export_libraries(path : String) -> void:
	var dir : Directory = Directory.new()
	var icon_path = path.get_basename()
	dir.make_dir(icon_path)
	var array = []
	serialize_library(array, "", null, icon_path)
	var file = File.new()
	if file.open(path, File.WRITE) == OK:
		file.store_string(JSON.print({lib=array}, "\t", true))
		file.close()


func generate_screenshots(graph_edit, item : TreeItem = null) -> int:
	var count : int = 0
	if item == null:
		item = tree.get_root()
	item = item.get_children()
	while item != null:
		if item.get_metadata(0) != null:
			var timer : Timer = Timer.new()
			add_child(timer)
			var new_nodes = graph_edit.create_nodes(item.get_metadata(0))
			timer.wait_time = 0.05
			timer.one_shot = true
			timer.start()
			yield(timer, "timeout")
			var image = get_viewport().get_texture().get_data()
			image.flip_y()
			image = image.get_rect(Rect2(new_nodes[0].rect_global_position-Vector2(1, 2), new_nodes[0].rect_size+Vector2(4, 4)))
			print(get_icon_name(get_item_path(item)))
			image.save_png("res://material_maker/doc/images/node_"+get_icon_name(get_item_path(item))+".png")
			for n in new_nodes:
				graph_edit.remove_node(n)
			remove_child(timer)
			count += 1
		var result = generate_screenshots(graph_edit, item)
		while result is GDScriptFunctionState:
			result = yield(result, "completed")
		count += result
		item = item.get_next()
	return count
