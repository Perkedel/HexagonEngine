# Copyright (c) 2019-2020 ZCaliptium.
tool
extends EditorPlugin

const DIALOGDB_NAME = "GDDlg_DialogDB";
const DLGPLR_NAME = "GDDlg_DialogPlayer";
const PluginSettings = preload("GDDlg_Settings.gd");

# When plugin got loaded.
func _enter_tree() -> void:
	add_autoload_singleton(DIALOGDB_NAME, "res://addons/gddlg/GDDlg_DialogDB.gd");
	add_custom_type(DLGPLR_NAME, "Node", load("res://addons/gddlg/GDDlg_DialogPlayer.gd"), load("res://addons/gddlg/GDDlg_DialogPlayer.png"));

	PluginSettings.load_settings();
	
# When plugin going to be unloaded.
func _exit_tree() -> void:
	remove_autoload_singleton(DIALOGDB_NAME);
	remove_custom_type(DLGPLR_NAME);
	pass;
