# Copyright (c) 2019-2020 ZCaliptium.
extends Node
class_name GDDlg_DialogPlayer

# Signals.
signal dialog_changed(previous);
signal options_updated();

# Fields.
var PreviousDialog: GDDlg_DialogDefinition = null;
var CurrentDialog: GDDlg_DialogDefinition = null;
var DialogOptions: Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Changes dialog to a new one using id. If dialog invalid returns false. Otherwise true.
func change_dialog_by_id(next_dialog_id: String) -> bool:
	var next_dialog: GDDlg_DialogDefinition = GDDlg_DialogDB.get_dialog_by_id(next_dialog_id);

	if (next_dialog == null):
		return false;

	change_dialog(next_dialog);
	return true;

# Changes dialog to a new one. Emits signal.
func change_dialog(next_dialog: GDDlg_DialogDefinition):
	PreviousDialog = CurrentDialog;
	CurrentDialog = next_dialog;
	emit_signal("dialog_changed", PreviousDialog);

func update_options():
	if (CurrentDialog == null):
		return;

	DialogOptions = [];
	var dialog_options: Array = CurrentDialog.options;

	# Iterate through dialog options.
	for i in range(0, dialog_options.size()):
		var option: Dictionary = dialog_options[i];

		var option_conditions: Array = option.get("conditions", []);

		if (!test_conditions(option_conditions)):
			continue;

		# If option available then add it into list.
		DialogOptions.append(option);
		
	emit_signal("options_updated");

func test_conditions(conditions: Array) -> bool:
	# Iterate through conditions.
	for j in range(0, conditions.size()):
		var condition_data = conditions[j];

		var condition = GDDlg_DialogDB.get_condition_by_id(condition_data["type"]);

		# Skip invalid condition.
		if (condition == null):
			continue;

		# If one condition doesn't pass. Then go out.
		if (!condition.test_condition(condition_data, self)):
			return false;

	return true;
