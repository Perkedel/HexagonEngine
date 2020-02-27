# Copyright (c) 2019-2020 ZCaliptium.
extends GDDlg_ConditionBase
class_name GDDlg_ConditionOr

# | A | B | Out |
# |---|---|-----|
# | 0 | 0 |  0  |
# | 0 | 1 |  1  |
# | 1 | 0 |  1  |
# | 1 | 1 |  1  |

func parse_internal(condition_data: Dictionary) -> bool:
	var values = condition_data.get("values", []);
	
	if (values == null):
		return false;
	
	if (typeof(values) != TYPE_ARRAY):
		return false;

	# Parse nested conditions.
	for i in range(0, values.size()):
		var value = values[i];
		
		if (typeof(value) != TYPE_DICTIONARY):
			return false;

		# If not parsed then exit with error.
		if (!GDDlg_ConditionBase.parse_base(value)):
			return false;
	
	return true;

func test_condition(var condition_data: Dictionary, var actor: Object) -> bool:
	var values: Array = condition_data.get("values");

	# Check nested conditions.
	for i in range (0, values.size()):
		var value: Dictionary = values[i];
		var condition_def = GDDlg_DialogDB.get_condition_by_id(value.get("type"));

		# If any of conditions applies.
		if (condition_def.test_condition(value, actor)):
			return true;

	return false;
