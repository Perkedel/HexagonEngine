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
	#FocusPlayButtonNow()
	CloseTheDrawer()
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

func CloseTheDrawer():
	$MainMenu.CloseTheDrawer()
	pass

func OpenTheDrawer():
	$MainMenu.OpenTheDrawer()
	pass

func _notification(what):
	# https://godotengine.org/qa/4768/android-ios-application-lifecycle
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# quitting app or back-button on Android
		print("Quit Request")
		AttempTheQuitGame()
		pass
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT && OS.get_name().nocasecmp_to("windows") != 0:
		print("Hexagon Engine Defocused!")
		pass
	pass

func _input(event):
	if event.is_action_pressed("ui_up"):
		CloseTheDrawer()
		pass
	if event.is_action_pressed("ui_down"):
		OpenTheDrawer()
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
	print("Dialog Yes Button")
	#FocusPlayButtonNow()
	CloseTheDrawer()
	if DialogSelectAction == DialogConfirmsFor.Nothing:
		
		pass
	elif DialogSelectAction == DialogConfirmsFor.ChangeDVD:
		
		pass
	elif DialogSelectAction == DialogConfirmsFor.QuitGame:
		get_tree().quit()
		pass
	pass

func DoDialogNoButtonOf():
	print("Dialog No Button")
	#FocusPlayButtonNow()
	CloseTheDrawer()
	pass

func DoDialogAwayHideOf():
	print("Dialog Go Away")
	CloseTheDrawer()
	pass

func AttempTheQuitGame():
	if $AreYouSureDialog.isSpawned:
		$AreYouSureDialog.NoCancel()
		pass
	else:
		SetSpawnDialogContextFor(DialogConfirmsFor.QuitGame)
		pass
	pass

func AttemptTheChangeDVD():
	if $AreYouSureDialog.isSpawned:
		$AreYouSureDialog.NoCancel()
		pass
	else:
		SetSpawnDialogContextFor(DialogConfirmsFor.ChangeDVD)
		pass
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
	AttemptTheChangeDVD()
	pass # Replace with function body.


func _on_MainMenu_PressExit():
	AttempTheQuitGame()
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


func _on_AreYouSureDialog_popup_hide():
	DoDialogAwayHideOf()
	pass # Replace with function body.

func SpawnLoadingBar():
	$LoadingPopup.SpawnLoading()
	pass

func DespawnLoadingBar():
	$LoadingPopup.DespawnLoading()
	pass

func ManageLoading(ProgressValuei, WordingHint, isComplete = false):
	$LoadingPopup.ManageLoading(ProgressValuei, WordingHint, isComplete)
	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
func _on_NextMenu_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	emit_signal("PleaseLoadThisLevelOf", a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass # Replace with function body.
