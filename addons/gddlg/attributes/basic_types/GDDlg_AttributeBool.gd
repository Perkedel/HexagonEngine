# Copyright (c) 2019-2020 ZCaliptium.
extends GDDlg_AttributeBase
class_name GDDlg_AttributeBool

func parse(attribute_data) -> bool:
	return typeof(attribute_data) == TYPE_BOOL;
