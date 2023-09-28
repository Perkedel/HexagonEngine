extends Control


@export var load_locations: Array[String]
@export var export_locations: Array[String]

@onready var tree: Tree = $Tree
@onready var text: TextEdit = $Text
@onready var license_manager: LicenseManager = $LicenseManager
@onready var op_locations: OptionButton = $op_locations


var root: TreeItem
var engine: TreeItem
var game: TreeItem
var licenses: TreeItem

var copyright: String

var location_index: int = 0

# key = identifier
# value = TreeItem
var licenses_dict = {}

func _ready() -> void:
	if not DirAccess.dir_exists_absolute("res://licenses/license_links/"):
		DirAccess.make_dir_recursive_absolute("res://licenses/license_links/")
	
	refresh_after_location_change()
	reload_license_manager()


func refresh_after_location_change():
	text.clear()
	
	if load_locations.size() == 0:
		load_locations.append('res://licenses')
		export_locations.clear()
		export_locations.append('user://licenses/game/')
	
	location_index = 0
	op_locations.clear()
	for i in load_locations.size():
		op_locations.add_item(load_locations[i])


func reload_license_manager():
	text.clear()
	license_manager.exclude_engine = location_index > 0
	tree.clear()
	
	license_manager.load_dir = load_locations[location_index]
	license_manager.export_dir = export_locations[location_index]
	license_manager.load_license_information()
	
	copyright = license_manager.get_combined_copyright()

	root = tree.create_item()
	var combined = tree.create_item(root)
	combined.set_text(0, "All Components")
	combined.set_meta('mode', 'combined')

	game = tree.create_item()
	var _name = 'Game' if location_index == 0 else 'Mod'
	if _name == 'Game' and ProjectSettings.has_setting('application/config/name'):
		_name = ProjectSettings.get_setting('application/config/name')
	game.set_text(0, _name)
	game.set_meta('mode', 'parent')

	if not license_manager.exclude_engine:
		engine = tree.create_item()
		engine.set_text(0, 'Godot Engine')
		engine.set_meta('mode', 'parent')

	licenses = tree.create_item()
	licenses.set_text(0, 'Licenses')
	licenses.set_meta('mode', 'parent')

	var item: TreeItem
	
	var used_licenses = {}

	for parent_component in license_manager.license_links.by_parent:
		for link in license_manager.license_links.by_parent[parent_component].values():
			if link is LicenseLink:
				match parent_component:
					"Game":
						item = tree.create_item(game)
					"Godot Engine":
						item = tree.create_item(engine)
				var valid_ids = license_manager.get_all_valid_licenses(link)
				for id in valid_ids:
					used_licenses[id] = valid_ids[id]
				item.set_text(0, link.componet_name)
				item.set_meta('mode', 'link')
				item.set_meta('link', link)

	for license in used_licenses.values():
		if license is License:
			item = tree.create_item(licenses)
			item.set_text(0, license.identifier)
			item.set_meta('mode', 'license')
			item.set_meta('license', license)
			licenses_dict[license.identifier] = item


func _on_tree_item_selected() -> void:
	var item = tree.get_selected()
	var mode = item.get_meta('mode')
	match mode:
		'combined':
			text.text = copyright
		'parent':
			pass
		'link':
			var link = item.get_meta('link') as LicenseLink
			text.text = link.to_formatted_string(link.component_of == 'Godot Engine')
		'license':
			var license = item.get_meta('license') as License
			text.text = license.terms


func _on_tree_item_activated() -> void:
	var item = tree.get_selected()
	var mode = item.get_meta('mode')
	match mode:
		'parent':
			item.collapsed = not item.collapsed
		'link':
			var link = item.get_meta('link') as LicenseLink
			for id in link.license_identifiers:
				if licenses_dict.has(id):
					var to = licenses_dict[id]
					to.select(0)
					tree.scroll_to_item(to)
					break


func _on_btn_open_data_dir_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir())


func _on_button_pressed() -> void:
	license_manager.export()


func _on_op_locations_item_selected(index: int) -> void:
	location_index = index
	reload_license_manager()
