# Copyright (c) 2019-2020 ZCaliptium.
extends Object

const PREFIX = "PluginSettings/gddlg/"

const PROP_PATHS       = PREFIX + "DialogJsonPaths";
const PROP_LOADONREADY = PREFIX + "LoadOnReady";
const PROP_STRICTDIALOGATTRIBUTES = PREFIX + "StrictDialogAttributes";
const PROP_STRICTOPTIONATTRIBUTES = PREFIX + "StrictOptionAttributes";

const PROPERTIES: Array = [
	{
		"name": PROP_PATHS,
		"type": TYPE_STRING_ARRAY,
		"hint": PROPERTY_HINT_DIR
	},
	{
		"name": PROP_LOADONREADY,
		"type": TYPE_BOOL
	},
	{
		"name": PROP_STRICTDIALOGATTRIBUTES,
		"type": TYPE_BOOL
	},
	{
		"name": PROP_STRICTOPTIONATTRIBUTES,
		"type": TYPE_BOOL
	}
];

const DEFAULTS: Dictionary = {
	PROP_PATHS: {},
	PROP_LOADONREADY: true,
	PROP_STRICTDIALOGATTRIBUTES: false,
	PROP_STRICTOPTIONATTRIBUTES: false
};

# Loads settings related to this plugin.
static func load_settings() -> void:
	for i in range(0, PROPERTIES.size()):
		var property_info: Dictionary = PROPERTIES[i];
		set_default(property_info["name"], DEFAULTS.get(property_info["name"]));
		ProjectSettings.add_property_info(property_info);
	
static func get_option(name: String):
	return ProjectSettings.get(name);

# Sets project property if not exists.
static func set_default(name: String, value) -> void:
	if (!ProjectSettings.has_setting(name)):
		ProjectSettings.set(name, value);
