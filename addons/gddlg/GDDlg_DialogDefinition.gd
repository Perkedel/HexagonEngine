# Copyright (c) 2019-2020 ZCaliptium.
extends Object
class_name GDDlg_DialogDefinition

# Fields.
var identifier: String;
var attributes: Dictionary = {};
var options: Array = [];

# Constructor.
func _init(id: String) -> void:
	identifier = id;

func get_attribute(key: String, default = null):
	return attributes.get(key, default);
