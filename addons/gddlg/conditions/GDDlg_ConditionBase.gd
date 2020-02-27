# Copyright (c) 2019-2020 ZCaliptium.
extends Object
class_name GDDlg_ConditionBase

static func parse_base(condition_data) -> bool:
	# Condition itself should be dictionary.
	if (typeof(condition_data) != TYPE_DICTIONARY):
		return false;
		
	var type = condition_data.get("type");
	
	if (type == null):
		return false;
		
	if (typeof(type) != TYPE_STRING):
		return false;
	
	var condition_def: GDDlg_ConditionBase = GDDlg_DialogDB.get_condition_by_id(type);

	if (condition_def == null):
		return false;

	return condition_def.parse_internal(condition_data);

func parse_internal(condition_data: Dictionary) -> bool:
	return true;

func test_condition(var condition_data: Dictionary, var actor: Object) -> bool:
	return true;
