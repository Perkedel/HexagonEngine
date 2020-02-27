extends Area2D

# FYI, this does use a group, so name collision is possible.
# probably not an issue, since the group name is so specific.

# USAGE
# 1. Add a shape
# 2. set up collision layers to limit this to the player (or
#    whatever's controlling the camera focal point)
# 3. give this node children named limit_top, limit_left, etc.
#    I use Position2D, since the only thing they're used for
#    is their global position.

func _ready():
	connect("body_entered", self, "entered")
	connect("body_exited", self, "exited")

func entered(thing):
	get_tree().call_group("markopolodev_camera", "set_limits", get_limits())

func exited(thing):
	get_tree().call_group("markopolodev_camera", "clear_limits", get_limits())

func get_limits():
	var result = {}
	if has_node("limit_top"):
		result["limit_top"] = $limit_top.get_global_position().y
	
	if has_node("limit_bottom"):
		result["limit_bottom"] = $limit_bottom.get_global_position().y
	
	if has_node("limit_left"):
		result["limit_left"] = $limit_left.get_global_position().x
	
	if has_node("limit_right"):
		result["limit_right"] = $limit_right.get_global_position().x
	
	return result



