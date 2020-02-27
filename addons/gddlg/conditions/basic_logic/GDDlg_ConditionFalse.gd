# Copyright (c) 2019-2020 ZCaliptium.
extends GDDlg_ConditionBase
class_name GDDlg_ConditionFalse

func parse_internal(condition_data: Dictionary) -> bool:
	return true;

func test_condition(var condition_data: Dictionary, var actor: Object) -> bool:
	return false;
