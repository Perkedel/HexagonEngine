@tool
#class_name
extends VBoxContainer
## A UI element to help display SectionResource(s)[br]
## [br]
## Makes use mostly of Godot's Tree and TreeItem

var root: TreeItem

@onready var name_label: Label = $Name
@onready var tree: Tree = $Tree

func _ready() -> void:
	root = tree.create_item()
	tree.hide_root = true
	return

## Accepts a SectionResource as a parameter
func display(res: SectionResource) -> void:
	name_label.text = res.name
	
	# For every ItemResource of the SectionResource passed in,
	# create a TreeItem, set its text,
	# and most importantly, set the TreeItem's metadata to itself
	var items: Array[ItemResource] = res.items # For auto-completion
	for item in items:
		if not item:
			push_warning("Godot Style: Empty ItemResource")
			continue
		
		var tree_item := tree.create_item(root)
		tree_item.set_autowrap_mode(0, TextServer.AUTOWRAP_WORD_SMART)
		tree_item.set_text(0, item.name)
		tree_item.set_metadata(0, item) # Set every TreeItem's metadata to its corresponding ItemResource
	
	# Ensures that even if the Style tab is resized,
	# every Tree will always be fully displayed.
	# -> Disregarding Trees' scroll function 
	# -> Only ScrollContainer in Main is used for scrolling
	_update_Tree_minimum_size()
	return


func _update_Tree_minimum_size() -> void:
	# Getting the height of the first TreeItem
	# Look into Godot Rect2D for more details
	var item_area_rect := tree.get_item_area_rect(
		root.get_first_child()
	)
	
	# Calculating the new minimum height
	# Assuming every TreeItem will be the same height
	# (TreeItem's autowrap is off)
	var new_custom_height: float = 0
	new_custom_height += item_area_rect.size.y
	new_custom_height += 4.0 # Taking v_seperation of Tree into consideration
	new_custom_height *= root.get_child_count()
	
	## Setting the new minimum height
	tree.set_custom_minimum_size(Vector2(
		0,
		new_custom_height
	))
	return
