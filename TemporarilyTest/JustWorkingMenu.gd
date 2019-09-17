extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal PressShutDown
func _on_PowerOffButton_pressed():
	emit_signal("PressShutDown")
	pass # Replace with function body.


func _on_ItemList_item_selected(index):
	pass # Replace with function body.
