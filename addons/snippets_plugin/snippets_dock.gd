tool
extends Control

var snippets_path = ""
var ext_editor_path = ""
var config = ConfigFile.new()


func _ready():
	# Get Initial Snippets Path
	get_snippets_path()
	# Get Snippets List
	get_snippets()

func get_snippets_path():
	var err = config.load("res://addons/snippets_plugin/snippets_plugin.cfg")
	if err == OK:
		snippets_path = config.get_value("snippets", "snippets_folder")
	# Store a variable if and only if it hasn't been defined yet
	if not config.has_section_key("location", "snippets_folder") or check_dir() == false: # Or Folder not found
		config.set_value("snippets", "snippets_folder", ProjectSettings.globalize_path("res://addons/snippets_plugin/snippets"))
		# Save the changes by overwriting the previous file
		config.save("res://addons/snippets_plugin/snippets_plugin.cfg")

func check_dir(path):
	# Check if folder exists
	var dir = Directory.new()
	if dir.dir_exists(path):
		return(true)
	else:
		return(false)

func update_snippets_path():
	# Update snippets config file with current snippets path
	var err = config.load("res://addons/snippets_plugin/snippets_plugin.cfg")
	if err == OK:
		config.set_value("snippets", "snippets_folder", snippets_path)
		config.save("res://addons/snippets_plugin/snippets_plugin.cfg")

func add_files_to_tree(files):
	# Clear any existing content (to allow us to repopulate without having to do extra work)
	$menu/Tree.clear()
	# Create the first (root) item
	var root = $menu/Tree.create_item()
	# Enable the "Expand" flag of Control.
	$menu/Tree.set_column_expand(0, true)
	# Hide the root (only display children)
	$menu/Tree.set_hide_root(true)

	for file in files:
		var file_node = $menu/Tree.create_item(root)
		# Metadata is used in order to double click
		# the item and copy the file to clipboard
		file_node.set_metadata(0, snippets_path + "/" + file)
		# Add Default Snippet description to metadat
		file_node.set_metadata(1, "Snippet Description goes here...")
		# The text/name that is displayed in the content tree
		file_node.set_text(0, file)

	# Hide the Description Column
	$menu/Tree.set_column_expand(1,false)


func list_files_in_directory(path):
	# List files in a folder
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
	    var file = dir.get_next()
	    if file == "":
	        break
	    elif dir.current_is_dir():
	        #print("folder found") # skip
	        pass
	    elif file.ends_with(".txt"):
	        files.append(file)
	dir.list_dir_end()
	return files

func deletefile(path):
	# Delete file in a folder
	var dir = Directory.new()
	dir.remove(path)


func savefile(content, path):
	# save text content to file
	var file = File.new()
	file.open(str(path), file.WRITE)
	file.store_string(content)
	file.close()

func loadfile(path):
	# load text content from file
	var file = File.new()
	file.open(str(path), file.READ)
	var content = file.get_as_text()
	file.close()
	return content

func copy_to_clipboard():
	# copy the resource (script) to clipboard
	var file = $menu/Tree.get_selected().get_metadata(0)
	var snippet = loadfile(file)
	OS.set_clipboard(snippet) # Copy to clipboard

func paste_from_clipboard():
	# paste resource (script) from clipboard
	OS.get_clipboard() # Paste from clipboard

func _on_Tree_item_activated():
	# Edit the text file in default external editor
	$menu/Tree/SnipMenu.rect_position = get_global_mouse_position()
	$menu/Tree/SnipMenu.visible = true
	$menu/Tree/SnipMenu.popup()

func get_snippets():
	# Load files to nodes in tree
	var snipfiles = list_files_in_directory(snippets_path)
	add_files_to_tree(snipfiles)
	update_statusbar("Files Refreshed...")

func _on_btnRefresh_pressed():
	# When refresh button pressed get snippets
	get_snippets()

func _on_btnFolder_pressed():
	# Open filedialog to select folder for snippets
	update_statusbar("Select Snippets Folder...")
	$FileDialog.set_mode( FileDialog.MODE_OPEN_DIR)
	$FileDialog.current_dir = snippets_path
	$FileDialog.update()
	# Position file dialog at mouse
	$FileDialog.rect_position = get_global_mouse_position()
	$FileDialog.popup()

func _on_btnClipboard_pressed():
	if $menu/Tree.get_selected():
		copy_to_clipboard()
		update_statusbar("Copied to Clipboard...")
	else:
		update_statusbar("Nothing Selected...")

func update_statusbar(info):
	$msgTimer.set_wait_time(5)
	$msgTimer.start()
	$menu/Statusbar.text = ""
	$menu/Statusbar.text = info

func _on_btnFolder_mouse_entered():
	$menu/buttons/btnFolder.hint_tooltip = snippets_path

func _on_Tree_item_selected():
	update_statusbar("Snippet Selected...")
	pass

func _on_SnipMenu_id_pressed(ID):
	match ID:
		0: # Edit file in internal editor
			int_editor()
		1: # Edit file in external editor if defined
			if not ext_editor_path == "":
				ext_editor()
			else:
				# Popup error msg if ext editor not defined
				update_statusbar("External Editor not configured...")
		2: # Show file in file manager
			print("Show in File Manager")
	#		print($menu/Tree.get_selected().get_metadata(0).get_base_dir())
			update_statusbar("Opened in File Manager...")
			OS.shell_open($menu/Tree.get_selected().get_metadata(0).get_base_dir())

func ext_editor():
	# use external editor
	update_statusbar("Opened in External Editor...")
	# get file path from tree node metadata
	var path = $menu/Tree.get_selected().get_metadata(0)
	var args = PoolStringArray()
	args.append(path)
	OS.execute(ext_editor_path, args, false)

func shell_editor():
	# use shell editor for txt files
	var path = $menu/Tree.get_selected().get_metadata(0)
	update_statusbar("Handled by txt extension...")
	OS.shell_open(path)

func int_editor():
	# use internal editor
	var path = $menu/Tree.get_selected().get_metadata(0)
	$snippet_editor.snippet_path = path
	$snippet_editor/vbox/code.text = loadfile(path)
	$snippet_editor.popup_centered()

func _on_Tree_item_rmb_selected(position):
#		print("Right Mouse Button")
		$menu/Tree/SnipMenu.rect_position = get_global_mouse_position()
		$menu/Tree/SnipMenu.visible = true
		$menu/Tree/SnipMenu.popup()

func _on_btnAddSnippet_pressed():
	# Add Clipboard to New Snippet
#	print("Copy Clipboard to Snippet")
	# paste resource (script) from clipboard
	$FileDialog.set_mode(FileDialog.MODE_SAVE_FILE)
	$FileDialog.current_dir = snippets_path
	$FileDialog.add_filter("*.txt")
	$FileDialog.deselect_items()
	$FileDialog.update()
	$FileDialog.rect_position = get_global_mouse_position()
	$FileDialog.popup()

func _on_btnDelSnippet_pressed():
	if $menu/Tree.get_selected():
		deletefile($menu/Tree.get_selected().get_metadata(0))
		get_snippets()
	else:
		update_statusbar("Nothing Selected...")

func _on_msgTimer_timeout():
	# when timer times out (5secs) clear text from statusbar
	$menu/Statusbar.text = ""


func _on_FileDialog_file_selected(path):
#	print(OS.get_clipboard() + "\n" + $FileDialog.current_path)
	savefile(OS.get_clipboard(),path) # Paste from clipboard to file
	update_statusbar("Snippet Added...")
	get_snippets()


func _on_FileDialog_dir_selected(dir):
	# if dir selected then update the snippets folder in config file
	snippets_path = dir
	update_snippets_path()
	update_statusbar("Folder Selected...")
	get_snippets()

func _on_btnHelp_pressed():
	# show help windows dialog
	$Help.rect_position=get_global_mouse_position()
	$Help.popup()
