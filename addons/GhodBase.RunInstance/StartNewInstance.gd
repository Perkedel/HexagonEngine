tool
extends EditorPlugin

var dock : NewInstanceDocker # A class member to hold the dock during the plugin lifecycle

func _enter_tree():
	# Initialization of the plugin goes here
	# First load the dock scene and instance it:
	dock = preload("res://addons/GhodBase.RunInstance/NewInstanceDocker.tscn").instance()

	# Add the loaded scene to the docks:
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock

func _exit_tree():
	# Clean-up of the plugin goes here
	# Remove the scene from the docks:
	remove_control_from_docks(dock) # Remove the dock
	dock.free() # Erase the control from the memory
