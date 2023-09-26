@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("XRControllerMidiPlayer", "Node", preload("xr_controller_midi_player.gd"), preload("icon.png"))

func _exit_tree():
	remove_custom_type("XRControllerMidiPlayer")
