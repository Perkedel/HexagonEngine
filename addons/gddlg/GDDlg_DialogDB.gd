# Copyright (c) 2019-2020 ZCaliptium.
extends Node

const PluginSettings = preload("GDDlg_Settings.gd");
const DialogDefinition = preload("GDDlg_DialogDefinition.gd");

var DIALOGS: Dictionary = {};
var DLGATTRIBUTES: Dictionary = {}
var OPTATTRIBUTES: Dictionary = {}
var CONDITIONS: Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var isLoadOnReady: bool = PluginSettings.get_option(PluginSettings.PROP_LOADONREADY);
	
	register_condition("true", GDDlg_ConditionBase.new());
	register_condition("false", GDDlg_ConditionFalse.new());
	register_condition("not", GDDlg_ConditionNot.new());
	register_condition("and", GDDlg_ConditionAnd.new());
	register_condition("or", GDDlg_ConditionOr.new());
	register_condition("nor", GDDlg_ConditionNor.new());
	
	if (isLoadOnReady):
		load_data();

func register_dialog_attribute(identifier: String, instance: GDDlg_AttributeBase):
	DLGATTRIBUTES[identifier] = instance;
	
func register_option_attribute(identifier: String, instance: GDDlg_AttributeBase):
	OPTATTRIBUTES[identifier] = instance;

func register_condition(identifier: String, instance: GDDlg_ConditionBase):
	CONDITIONS[identifier] = instance;

# Loads all item definitions from specified paths.
func load_data() -> void:
	var paths: Array = PluginSettings.get_option(PluginSettings.PROP_PATHS);
	
	print("[gddlg] Dialog JSON directories count... ", paths.size());

	# Iterate through array.
	for i in range(0, paths.size()):
		var path: String = paths[i];
		
		if (!path.empty()):
			print("  [", i, "] - ", path);
			load_dialogs_from_dir(path);
		else:
			print("  [", i, "] - Empty");

# Tries to load JSON files from specified directory.
func load_dialogs_from_dir(path: String) -> void:
	var dir = Directory.new();
	
	# If directory exist.
	if (dir.open(path) == OK):
		dir.list_dir_begin(true);
		var file_name = dir.get_next();
		
		# Until we have entries...
		while (file_name != ""):
			if (!dir.current_is_dir() && file_name.ends_with(".json")):
				print("    ", file_name);
				load_dialog(path + file_name);
			file_name = dir.get_next();
		
		print("    End");

func load_dialog(url: String) -> void:
	var file = File.new();
	
	if (!file.file_exists(url)):
		print("      Failed to open file! Doesn't exist!");
		return;
	
	if (file.open(url, File.READ)):
		print("      Failed to open file!");
		return;

	#print("test: ", file.get_as_text())

	var json_result = JSON.parse(file.get_as_text());
	file.close();

	if (json_result.error != 0):
		print("      Parse error (", json_result.error, ")");
		return;

	#print("      Data: ", json_result.result);
	var dialog_data: Dictionary = json_result.result;
	parse_dialog_data(dialog_data);

func parse_dialog_data(dialog_data: Dictionary) -> void:
	var dialog_id: String = dialog_data.get("id");

	if (dialog_id == null):
		print("      Malformed json! Missing 'id' field!");
		return;
		
	var attributes = dialog_data.get("attributes", {});
	
	if (typeof(attributes) != TYPE_DICTIONARY):
		print("      Malformed json! Field 'attributes' is not map!");
		return;

	var options = dialog_data.get("options", []);

	if (typeof(options) != TYPE_ARRAY):
		print("      Malformed json! Field 'options' is not array!");
		return;
		
	var is_strict_attributes: bool = PluginSettings.get_option(PluginSettings.PROP_STRICTDIALOGATTRIBUTES);
	
	if (is_strict_attributes and !parse_dialog_attributes(attributes)):
		print("      Malformed json! Unknown dialog attribute!");
		return;
		
	var options_result = parse_dialog_options(options);
	if (!options_result):
		return;
		
	var new_dialog = DialogDefinition.new(dialog_id);

	new_dialog.options = options;
	new_dialog.attributes = attributes;
	DIALOGS[dialog_id] = new_dialog;
	
func parse_dialog_attributes(dialog_attributes: Dictionary) -> bool:
	for i in dialog_attributes.keys():
		var attribute_obj: GDDlg_AttributeBase = get_dialog_attribute_by_id(i);

		if (attribute_obj == null):
			return false;

		if (!attribute_obj.parse(dialog_attributes.get(i))):
			return false;

	return true;

func parse_dialog_options(dialog_options: Array) -> bool:
	for i in range(0, dialog_options.size()):
		var dialog_option = dialog_options[i];

		if (typeof(dialog_option) != TYPE_DICTIONARY):
			print("      Malformed json! Option [, i, ] is not map!");
			return false;

		var option_attributes = dialog_option.get("attributes", {});
		
		if (typeof(option_attributes) != TYPE_DICTIONARY):
			print("      Malformed json! Option [", i, "] -> 'attributes' is not map!");
			return false;

		var is_strict_attributes: bool = PluginSettings.get_option(PluginSettings.PROP_STRICTOPTIONATTRIBUTES);

		if (is_strict_attributes and !parse_option_attributes(option_attributes)):
			print("      Malformed json! Option [", i, "] Invalid attribute!");
			return false;

		var option_conditions = dialog_option.get("conditions", []);

		if (typeof(option_conditions) != TYPE_ARRAY):
			print("      Malformed json! Option [", i, "] -> 'conditions' is not array!");
			return false;
			
		for j in range(0, option_conditions.size()):
			var condition_data = option_conditions[j];
			
			if (!GDDlg_ConditionBase.parse_base(condition_data)):
				print("      Malformed json! Option [", i, "] -> Condition [", j, "]!");

	return true;

func parse_option_attributes(option_attributes: Dictionary) -> bool:
	for i in option_attributes.keys():
		var attribute_obj = get_option_attribute_by_id(i);
	
		if (attribute_obj == null):
			return false;
	
		if (!attribute_obj.parse(option_attributes.get(i))):
			return false;

	return true;
	
# Getter by key for definition registry.
func get_dialog_by_id(dialog_id: String) -> GDDlg_DialogDefinition:
	return DIALOGS.get(dialog_id);

# Getter by key for attribute registry.
func get_dialog_attribute_by_id(attribute_id: String) -> GDDlg_AttributeBase:
	return DLGATTRIBUTES.get(attribute_id);
	
# Getter by key for attribute registry.
func get_option_attribute_by_id(attribute_id: String) -> GDDlg_AttributeBase:
	return OPTATTRIBUTES.get(attribute_id);

# Getter by key for condition registry.
func get_condition_by_id(condition_id: String) -> GDDlg_ConditionBase:
	return CONDITIONS.get(condition_id);
