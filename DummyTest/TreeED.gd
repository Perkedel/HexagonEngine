extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var tree = Tree.new()
	var root = tree.create_item()
	tree.set_hide_root(true)
	var child1 = tree.create_item(root)
	var child2 = tree.create_item(root)
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
	
	#set_hide_root(true)
	var idontknow = TreeItem.new()
	#idontknow.set_button(0,1)
	create_item()
	var idkIteme = create_item(idontknow)
	idkIteme.set_text(0,"HEllo")
	create_item(child1)
	create_item(subchild1)
	create_item(root)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
