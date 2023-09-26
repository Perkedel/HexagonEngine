@tool
extends EditorPlugin


const SINGLETONS = {
	'EventBus': 'EventBus.gd',
	'Helpers': 'Helpers.gd',
}

const CUSTOM_TYPES = [
	[
		'Scene Switcher Button',
		'Button',
		preload("res://addons/godot_helpers/Nodes/Scene Switcher Button/Scene Switcher Button.gd"),
		preload("res://icon.svg")
	],
	[
		'Settings View',
		'VBoxContainer',
		preload("res://addons/godot_helpers/Nodes/Settings View/settings_view.gd"),
		preload("res://addons/godot_helpers/Nodes/Settings View/settings view icon.svg")
	],
	[
		'Panzoom Camera',
		'Camera2D',
		preload("res://addons/godot_helpers/Nodes/Panzoom Camera/panzoom_camera.gd"),
		preload("res://addons/godot_helpers/Nodes/Panzoom Camera/panzoom camera icon.svg")
	],
]

func _enter_tree():
	print('Initializing Godot Helpers')

	for key in SINGLETONS.keys():
		var path = 'Singletons/%s' % SINGLETONS[key]
		print('Loading "%s" Singleton at "%s"' % [key, path])
		add_autoload_singleton(key, path)

	for t in CUSTOM_TYPES:
		print('Adding "%s" as a custom type' % [ t[0] ])
		add_custom_type(t[0], t[1], t[2], t[3])


func _exit_tree():
	print('Deinitializing Godot Helpers')

	for key in SINGLETONS.keys():
		print('Clearing "%s" Singleton' % key)
		remove_autoload_singleton(key)

	pass
