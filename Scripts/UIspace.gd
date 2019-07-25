extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"
enum SelectMenuList {Setting=0,Unknown=1,Extras=2, Gameplay = 3, LevelSelect = 4}
export(SelectMenuList) var NextMenuScene
export(NodePath) var MainMenuNode
export(NodePath) var NextMenuNode
export(NodePath) var GameplayUINode

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/VBoxContainer/MenuButtonings/FocusArea/SamPlayArea/PlayButton.grab_focus()
	pass # Replace with function body.

func ShowNextMenu():
	$NextMenu.SelectYourMenu = NextMenuScene
	$NextMenu.show()
	$MainMenu.hide()

func SetAndShowNextMenu(WhichMenu):
	NextMenuScene = WhichMenu
	ShowNextMenu()
	pass

func BackToMainMenu():
	$GameplayUI.hide()
	$NextMenu.hide()
	$MainMenu.show()
	$MainMenu/VBoxContainer/TitleBox/TitleAnimating.play("InitTitle")
	$MainMenu/VBoxContainer/MenuButtonings/MenuButtonAnimations.play("InitMenu")
	$MainMenu/VBoxContainer/MenuButtonings/FocusArea/SamPlayArea/PlayButton.grab_focus()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_0):
		#NextMenu(PassMenuScene)
		ShowNextMenu()
		pass
	
	pass


func _on_MenuButtonings_PressChangeDVDButton():
	pass # Replace with function body.


func _on_MenuButtonings_PressExitButton():
	pass # Replace with function body.


func _on_MenuButtonings_PressExtrasButton():
	SetAndShowNextMenu(SelectMenuList.Extras)
	pass # Replace with function body.


func _on_MenuButtonings_PressSettingButton():
	SetAndShowNextMenu(SelectMenuList.Setting)
	pass # Replace with function body.


func _on_MenuButtonings_PressUnknownButton():
	SetAndShowNextMenu(SelectMenuList.Unknown)
	pass # Replace with function body.


func _on_BackButton_pressed(extra_arg_0):
	BackToMainMenu()
	pass # Replace with function body.
