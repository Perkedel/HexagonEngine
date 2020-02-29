tool
extends Tree

signal selected_files(selected)

const COLUMN_TITLES: = [
	"", "Name", "Extension", "Size", "Directory"
]
const Tools: Script = preload("tools.gd")

enum Column {CHECKED, NAME, EXTENSION, SIZE, DIRECTORY}

var checked_files: bool = false


func _notification(what: int) -> void:
	if Tools.is_node_being_edited(self):
		return
	if what == NOTIFICATION_RESIZED:
		if get_root():
			var item: TreeItem = get_root().get_children()
			while item:
				if item.get_meta("type") == "section":
					item = item.get_children()
					continue
				var dir: String = item.get_tooltip(Column.DIRECTORY)
				var d: String = Tools.fit_text(dir, get_column_width(Column.DIRECTORY) - 5, get_font("font"))
				item.set_text(Column.DIRECTORY, d)
				if item.get_next() or item.get_parent() == get_root():
					item = item.get_next()
				else:
					item = item.get_parent().get_next()


func get_files(all: bool) -> PoolStringArray:
	var files: = PoolStringArray()
	var item: TreeItem = get_root().get_children()
	while item:
		if item.get_meta("type") == "section":
			if all or item.is_checked(Column.CHECKED):
				item = item.get_children()
			else:
				item = item.get_next()
			continue
		if all or item.is_checked(Column.CHECKED):
			var file_name: String = item.get_text(Column.NAME)
			var ext: String = item.get_text(Column.EXTENSION)
			var dir_path: String = item.get_tooltip(Column.DIRECTORY)
			file_name = dir_path + "/" + file_name + "." + ext
			files.append(file_name)
		if item.get_next() or item.get_parent() == get_root():
			item = item.get_next()
		else:
			item = item.get_parent().get_next()
	return files


func _on_FolderPath_files_updated(file_names: PoolStringArray, base_dir_: String) -> void:
	clear()
	if file_names.size() == 0:
		set_column_titles_visible(false)
		var root: TreeItem = create_item()
		root.set_text(0, "(No files found)")
		root.set_selectable(0, false)
		self.hide_root = false
		self.columns = 1
		set_column_expand(0, true)
		return
	self.hide_root = true
	self.columns = 5
	set_column_titles_visible(true)
	var folders_data: Dictionary = {}
	var file: = File.new()
	for file_path in file_names:
			var file_name: String = file_path.get_file().get_basename()
			var ext: String = file_path.get_extension()
			var dir: String = file_path.get_base_dir()
			assert(file.open(file_path, File.READ) == OK)
			var fsize: int = file.get_len()
			file.close()
			var data: = {
				"name": file_name,
				"ext": ext,
				"size": fsize,
			}
			if !folders_data.has(dir):
				folders_data[dir] = []
			folders_data[dir].append(data)
	set_column_title(Column.CHECKED, COLUMN_TITLES[Column.CHECKED])
	set_column_expand(Column.CHECKED, false)
	set_column_min_width(Column.CHECKED, 40)
	set_column_title(Column.NAME, COLUMN_TITLES[Column.NAME])
	set_column_expand(Column.NAME, true)
	set_column_min_width(Column.NAME, 80)
	set_column_title(Column.EXTENSION, COLUMN_TITLES[Column.EXTENSION])
	set_column_expand(Column.EXTENSION, false)
	set_column_min_width(Column.EXTENSION, 50)
	set_column_title(Column.SIZE, COLUMN_TITLES[Column.SIZE])
	set_column_expand(Column.SIZE, false)
	set_column_min_width(Column.SIZE, 80)
	set_column_title(Column.DIRECTORY, COLUMN_TITLES[Column.DIRECTORY])
	set_column_expand(Column.DIRECTORY, true)
	set_column_min_width(Column.DIRECTORY, 80)

	var root: TreeItem = create_item()
	var base_dir: String = base_dir_.substr(0, base_dir_.length() - 1)
	for dir in folders_data:
		if dir == base_dir:
			continue
		var section: TreeItem = create_item(root)
		section.set_meta("type", "section")
		section.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		section.set_editable(0, true)
		var section_name: String = dir.right(dir.find_last("/") + 1)
		section.set_text(1, section_name)
		for data in folders_data[dir]:
			var row: TreeItem = create_item(section)
			row.set_meta("type", "file-section")
			row.set_cell_mode(Column.CHECKED, TreeItem.CELL_MODE_CHECK)
			row.set_editable(Column.CHECKED, true)
			row.set_text(Column.NAME, data["name"])
			row.set_text(Column.EXTENSION, data["ext"])
			row.set_text(Column.SIZE, Tools.int_to_bytestr(data["size"]))
			var d: String = Tools.fit_text(dir, get_column_width(Column.DIRECTORY) - 5, get_font("font"))
			row.set_text(Column.DIRECTORY, d)
			row.set_tooltip(Column.DIRECTORY, dir)
	if folders_data.has(base_dir):
		for data in folders_data[base_dir]:
			var row: TreeItem = create_item(root)
			row.set_meta("type", "file")
			row.set_cell_mode(Column.CHECKED, TreeItem.CELL_MODE_CHECK)
			row.set_editable(Column.CHECKED, true)
			row.set_text(Column.NAME, data["name"])
			row.set_text(Column.EXTENSION, data["ext"])
			row.set_text(Column.SIZE, Tools.int_to_bytestr(data["size"]))
			row.set_text(Column.DIRECTORY, base_dir)


func _on_item_selected() -> void:
	var item: TreeItem = get_selected()
	if item.get_meta("type") == "section":
		var col: int = get_column_at_position(get_local_mouse_position())
		if col != 0:
			item.collapsed = not item.collapsed
		else:
			item.select(0)


func _on_item_edited() -> void:
	var item: TreeItem = get_edited()
	if get_edited_column() == 0:
		var checked: bool = item.is_checked(0)
		if item.get_meta("type") == "section":
			var ch_item: TreeItem = item.get_children()
			while ch_item:
				ch_item.set_checked(0, checked)
				ch_item = ch_item.get_next()
		elif item.get_meta("type") == "file-section":
			var parent: TreeItem = item.get_parent()
			if checked && !parent.is_checked(0):
				parent.set_checked(0, true)
			else:
				var ch_item: TreeItem = parent.get_children()
				var all_inactive: bool = true
				while ch_item:
					if ch_item.is_checked(0):
						all_inactive = false
						break
					ch_item = ch_item.get_next()
				if all_inactive:
					parent.set_checked(0, false)
		if checked:
			if not checked_files:
				checked_files = true
				emit_signal("selected_files", true)
		else:
			var ch_item: TreeItem = get_root().get_children()
			var all_inactive: bool = true
			while ch_item:
				if ch_item.is_checked(0):
					all_inactive = false
					break
				ch_item = ch_item.get_next()
			if all_inactive and checked_files:
				checked_files = false
				emit_signal("selected_files", false)

