# Copyright (c) 2019-2020 ZCaliptium.
extends GDDlg_ConditionOr
class_name GDDlg_ConditionAnd

# | A | B | Out |
# |---|---|-----|
# | 0 | 0 |  0  |
# | 0 | 1 |  0  |
# | 1 | 0 |  0  |
# | 1 | 1 |  1  |

func test_condition(var condition_data: Dictionary, var actor: Object) -> bool:
	var values: Array = condition_data.get("values");
	
	for i in range (0, values.size()):
		var value: Dictionary = values[i];
		var condition_def = GDDlg_DialogDB.get_condition_by_id(value.get("type"));

		# If any of conditions doesn't apply.
		if (!condition_def.test_condition(value, actor)):
			return false;
	
	return true;
