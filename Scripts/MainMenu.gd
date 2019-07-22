extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum SelectMenuList {Setting=0,Unknown=1,Extras=2, Gameplay = 3}
export(SelectMenuList) var NextMenuScene
export(NodePath) var NextMenuNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ShowNextMenu(WhichMenu):
	get_node(NextMenuNode)
	get_node(NextMenuNode).show()
	hide()
	pass


func _on_MenuButtonings_PressChangeDVDButton():
	pass # Replace with function body.


func _on_MenuButtonings_PressExitButton():
	pass # Replace with function body.


func _on_MenuButtonings_PressExtrasButton():
	pass # Replace with function body.


func _on_MenuButtonings_PressSettingButton():
	pass # Replace with function body.


func _on_MenuButtonings_PressUnknownButton():
	pass # Replace with function body.
