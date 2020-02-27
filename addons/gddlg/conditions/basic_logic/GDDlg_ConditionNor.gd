# Copyright (c) 2019-2020 ZCaliptium.
extends GDDlg_ConditionOr
class_name GDDlg_ConditionNor

# | A | B | Out |
# |---|---|-----|
# | 0 | 0 |  1  |
# | 0 | 1 |  0  |
# | 1 | 0 |  0  |
# | 1 | 1 |  0  |

func test_condition(var condition_data: Dictionary, var actor: Object) -> bool:
	return !.test_condition(condition_data, actor);
