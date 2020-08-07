extends GridContainer


const InputEachActionLoad = preload("res://GameDVDCardtridge/HexagonEngine-v3/SpareParts/UI/MainUINodes/Controller/InputEachAction.tscn")

export(String) var FilterActionPrefixOf = "^ui_"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# https://github.com/AnJ95/godot-toolbox-project

export var pretty_action_names = {
	"game_left" : "Left",
	"game_right" : "Right",
	"game_up" : "Up",
	"game_down" : "Down",
	"game_jump" : "Jump",
	"game_interact" : "Interact",
	"game_switch_demo" : "Switch Demo",
	"game_switch_skin" : "Switch Skin",
	"game_pause" : "Pause"
}

export var preferred_order = [
	"game_left",
	"game_right",
	"game_up",
	"game_down",
	"game_jump",
	"game_interact",
	"game_pause",
	"game_switch_demo",
	"game_switch_skin"
]

# YOINK! your coding is now my property lol jk! XD
func add_actions():
	
	# Clear prev children
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	# get settings
	var settingsControls:Dictionary = Settingers.SettingData.ControllerMappings
	
	# Try to use preferred_order for the list of action names ...
	var action_names = preferred_order.duplicate()
	
	# ... but remove what doesn't actually exist ...
	for action_name in action_names:
		if !settingsControls.has(action_name):
			action_names.erase(action_name)
	
	# ... and append what's missing
	for action_name in settingsControls:
		if action_names.find(action_name) == -1:
			action_names.append(action_name)
	
	# ready regex to filter actions
	var regex = RegEx.new()
	regex.compile(FilterActionPrefixOf)
	
	# add one ControlMenuAction per InputMap action
	for action_name in action_names:
		
		# skip filtered actions
		if regex.search(action_name):
			continue
		
		# create and add instance
		var menu_action_inst = InputEachActionLoad.instance()
		menu_action_inst.init(action_name)
		add_child(menu_action_inst)
	
	var all_control_btns = get_tree().get_nodes_in_group("MenuControlButton")
	if all_control_btns.size() > 0:
		all_control_btns[0].grab_focus()

func reset_to_default():
	#PersistenceMngr.set_state("settingsControls", StateMngr.default_options_controls)
	
	add_actions()
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
