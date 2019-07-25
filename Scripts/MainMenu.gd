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

func ArriveAtMainMenu():
	ReplayMenuAnimation()
	pass

func ReplayMenuAnimation():
	$VBoxContainer/TitleBox.ReplayTitleAnimation()
	$VBoxContainer/MenuButtonings.ReplayButtoningAnimations()
	pass

func FocusPlayButtonNow():
	$VBoxContainer/MenuButtonings.BecauseCloseMenuDrawer()
	pass

func FocusMoreMenuButtonNow():
	$VBoxContainer/MenuButtonings.BecauseOpenMenuDrawer()
	pass

signal PressChangeDVD()
func _on_MenuButtonings_PressChangeDVDButton():
	emit_signal("PressChangeDVD")
	pass # Replace with function body.

signal PressExit()
func _on_MenuButtonings_PressExitButton():
	emit_signal("PressExit")
	pass # Replace with function body.

signal PressExtras()
func _on_MenuButtonings_PressExtrasButton():
	emit_signal("PressExtras")
	pass # Replace with function body.

signal PressSetting()
func _on_MenuButtonings_PressSettingButton():
	emit_signal("PressSetting")
	pass # Replace with function body.

signal PressUnknown()
func _on_MenuButtonings_PressUnknownButton():
	emit_signal("PressUnknown")
	pass # Replace with function body.

signal PressPlay()
func _on_MenuButtonings_PressPlayButton():
	emit_signal("PressPlay")
	pass # Replace with function body.
