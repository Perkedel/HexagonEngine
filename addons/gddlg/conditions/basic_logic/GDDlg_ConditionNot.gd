# Copyright (c) 2019-2020 ZCaliptium.
extends GDDlg_ConditionBase
class_name GDDlg_ConditionNot

# | A | Out |
# |---|-----|
# | 0 |  1  |
# | 1 |  0  |

func parse_internal(condition_data: Dictionary) -> bool:
	var value = condition_data.get("value", {});
	
	if (value == null):
		return false;
	
	if (typeof(value) != TYPE_DICTIONARY):
		return false;

	# Parse nested condition.
	return GDDlg_ConditionBase.parse_base(value);

func test_condition(var condition_data: Dictionary, var actor: Object) -> bool:
	var value: Dictionary = condition_data.get("value");

	var condition_def: GDDlg_ConditionBase = GDDlg_DialogDB.get_condition_by_id(value.get("type"));

	return !condition_def.test_condition(value, actor);
