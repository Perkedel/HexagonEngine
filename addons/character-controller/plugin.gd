@tool
extends EditorPlugin

const DefaultActions = preload("./default_actions.gd")

const ACTIONS = [
	DefaultActions.CHARACTER_CONTROLLER_FORWARD,
	DefaultActions.CHARACTER_CONTROLLER_BACKWARD,
	DefaultActions.CHARACTER_CONTROLLER_RIGHT,
	DefaultActions.CHARACTER_CONTROLLER_LEFT,
	DefaultActions.CHARACTER_CONTROLLER_SPRINT,
	DefaultActions.CHARACTER_CONTROLLER_JUMP,
	DefaultActions.CHARACTER_CONTROLLER_CROUCH,
	DefaultActions.CHARACTER_CONTROLLER_FLY_MODE
]

func _enter_tree():
	# Register input events
	for action_props in ACTIONS:
		var setting_name = "input/" + action_props["name"]

		if not ProjectSettings.has_setting(setting_name):
			var events = []

			var action_props_events = action_props["events"]

			for event_data in action_props_events:
				var event = InputEventKey.new()
				for prop_name in event_data:
					event.set(prop_name, event_data[prop_name])

				events.append(event)

			ProjectSettings.set_setting(setting_name, {
				"deadzone": float(action_props["deadzone"] if "deadzone" in action_props else 0.5),
				"events": events
			})

	var result = ProjectSettings.save()
	assert(result == OK, "Failed to save project settings")


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
