extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"
enum SelectMenuList {Setting=0,Unknown=1,Extras=2, Gameplay = 3, LevelSelect = 4}
export(SelectMenuList) var NextMenuScene
enum DialogConfirmsFor {Nothing = 0, ChangeDVD = 1, QuitGame = 2}
export(DialogConfirmsFor) var DialogSelectAction
export(NodePath) var MainMenuNode
export(NodePath) var NextMenuNode
export(NodePath) var GameplayUINode

# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenu/VBoxContainer/MenuButtonings/FocusArea/SamPlayArea/PlayButton.grab_focus()
	FocusPlayButtonNow()
	pass # Replace with function body.

func ShowNextMenu():
	#$NextMenu.SelectYourMenu = NextMenuScene
	$NextMenu.show()
	$MainMenu.hide()
	pass

func SetAndShowNextMenu(WhichMenu):
	NextMenuScene = WhichMenu
	$NextMenu.SetYourMenuList(WhichMenu)
	ShowNextMenu()
	pass

func BackToMainMenu():
	$GameplayUI.hide()
	$NextMenu.hide()
	$MainMenu.show()
	$MainMenu.ArriveAtMainMenu()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_0):
		#NextMenu(PassMenuScene)
		ShowNextMenu()
		pass
	
	pass

func FocusPlayButtonNow():
	$MainMenu.FocusPlayButtonNow()
	
	pass

func SetSpawnDialogContextFor(WhichContext):
	DialogSelectAction = WhichContext
	if WhichContext == DialogConfirmsFor.Nothing:
		$AreYouSureDialog.SpawnDialogWithAppendSure("do nothing")
		pass
	elif WhichContext == DialogConfirmsFor.ChangeDVD:
		$AreYouSureDialog.SpawnDialogWithAppendSure("change DVD")
		pass
	elif WhichContext == DialogConfirmsFor.QuitGame:
		$AreYouSureDialog.SpawnDialogWithAppendSure("shutdown this Hexagon Engine")
		pass
	pass

func DoDialogYesButtonOf():
	FocusPlayButtonNow()
	if DialogSelectAction == DialogConfirmsFor.Nothing:
		
		pass
	elif DialogSelectAction == DialogConfirmsFor.ChangeDVD:
		
		pass
	elif DialogSelectAction == DialogConfirmsFor.QuitGame:
		get_tree().quit()
		pass
	pass

func DoDialogNoButtonOf():
	FocusPlayButtonNow()
	pass

signal ChangeDVD_Exec
func ChangeTheDVDNow():
	emit_signal("ChangeDVD_Exec")
	pass

signal Shutdown_Exec
func ExecuteShutdown():
	emit_signal("Shutdown_Exec")
	pass

func _on_BackButton_pressed(extra_arg_0):
	BackToMainMenu()
	pass # Replace with function body.


func _on_MainMenu_PressChangeDVD():
	SetSpawnDialogContextFor(DialogConfirmsFor.ChangeDVD)
	pass # Replace with function body.


func _on_MainMenu_PressExit():
	SetSpawnDialogContextFor(DialogConfirmsFor.QuitGame)
	pass # Replace with function body.


func _on_MainMenu_PressExtras():
	SetAndShowNextMenu(SelectMenuList.Extras)
	pass # Replace with function body.


func _on_MainMenu_PressPlay():
	SetAndShowNextMenu(SelectMenuList.LevelSelect)
	pass # Replace with function body.


func _on_MainMenu_PressSetting():
	SetAndShowNextMenu(SelectMenuList.Setting)
	pass # Replace with function body.


func _on_MainMenu_PressUnknown():
	SetAndShowNextMenu(SelectMenuList.Unknown)
	pass # Replace with function body.

func _on_NextMenu_PressBackButton():
	BackToMainMenu()
	pass # Replace with function body.


func _on_AreYouSureDialog_YesImSure():
	DoDialogYesButtonOf()
	pass # Replace with function body.


func _on_AreYouSureDialog_NoImNotSure():
	DoDialogNoButtonOf()
	pass # Replace with function body.
