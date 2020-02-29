tool
extends VBoxContainer

"""
Looks for models in the selected workspace folder and gives options
to load one or more models.

The 3D model files found in the workspace directory (including
sub-folder one level deep) are displayed in FoundModels/FileTree. The
models shown here are not loaded into memory automatically. To load
any models, it should be selected in the file tree and press the
LoadBox/Load button. Also, when LoadBox/LoadAll is pressed, all found
models are loaded even if they are not selected in FoundModels/FileTree.

The Loader node is responsible for loading the models. The loading
process is done without blocking the main thread. Loaded files are shown
in LoadedModels/List as a list of items. Whenever one of these items is
selected, the Loader node will call the 'update_model' function on every
node belonging to the 'SpriteBaker.Model' group as:

model_group_node.update_model(selected_model)

The LoadBox/Clear button can be used to unload from memory all loaded
models. This is done by calling the 'clear_model' function on nodes from
the 'SpriteBaker.Model'. There is no warranty that the models will be
actually unloaded. For this to happen any node from the 'SpriteBaker.Model'
group should delete any reference or duplicates of the original model.
"""

const Tools: Script = preload("tools.gd")

export(NodePath) var folder_node_path: NodePath
export(NodePath) var file_tree_path: NodePath
export(NodePath) var file_list_path: NodePath
export(NodePath) var load_all_path: NodePath
export(NodePath) var load_path: NodePath
export(NodePath) var clear_path: NodePath

onready var folder: LineEdit = get_node(folder_node_path)
onready var file_list: ItemList = get_node(file_list_path)
onready var file_tree: Tree = get_node(file_tree_path)

var original_path: String


func _ready() -> void:
	if not Tools.is_node_being_edited(self):
		folder.folder_path = Tools.get_addon_path(self) + "models/"

		## DEBUG: Load all models when not in the editor
		if not Engine.is_editor_hint() and file_tree.get_root():
			_on_LoadAll_pressed()


func load_models(all: bool) -> void:
	var files: PoolStringArray = file_tree.get_files(all)
	$Loader.load_models(files)


func _on_SearchFolder_pressed() -> void:
	var dialog: FileDialog
	for node in get_tree().get_nodes_in_group("SpriteBaker.FileDialog"):
		if node is FileDialog:
			dialog = node
			break
	original_path = dialog.current_dir
	dialog.current_dir = folder.folder_path
	dialog.mode = FileDialog.MODE_OPEN_DIR
	dialog.popup_centered(Vector2(500, 500))
	if not dialog.is_connected("dir_selected", self, "_on_dir_selected"):
		assert(dialog.connect("dir_selected", self, "_on_dir_selected", [dialog]) == OK)


func _on_dir_selected(dir: String, dialog: FileDialog) -> void:
	folder.folder_path = dir
	dialog.disconnect("dir_selected", self, "_on_dir_selected")
	dialog.current_dir = original_path


func _on_FolderPath_files_updated(file_names: PoolStringArray, _base_dir: String) -> void:
	get_node(load_all_path).disabled = file_names.size() == 0


func _on_FileTree_selected_files(selected: bool) -> void:
	get_node(load_path).disabled = !selected


func _on_LoadAll_pressed() -> void:
	load_models(true)


func _on_Load_pressed() -> void:
	load_models(false)


func _on_Loader_loading_finished() -> void:
	file_list.clear()
	for imodel in range($Loader.files.size()):
		var file_name: String = $Loader.files[imodel]
		var item_name: String = file_name.get_file()
		file_list.add_item(item_name)
		file_list.set_item_metadata(imodel, imodel) # When sorted alphabetically the index can change
		file_list.set_item_tooltip(imodel, file_name)
	file_list.sort_items_by_text()
	get_node(clear_path).disabled = false

	## DEBUG: Select first model, if exist
	if not Engine.is_editor_hint() and file_list.get_item_count() != 0:
		_on_List_item_selected(0)


func _on_Clear_pressed() -> void:
	for node in get_tree().get_nodes_in_group("SpriteBaker.Model"):
		node.clear_model()
	get_node(clear_path).disabled = true
	file_list.clear()
	$Loader.clear()


func _on_List_item_selected(index: int) -> void:
	var id: int = file_list.get_item_metadata(index)
	$Loader.select(id)
