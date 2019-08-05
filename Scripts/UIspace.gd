extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"
enum SelectMenuList {MainMenu=-1, Setting=0,Unknown=1,Extras=2, Gameplay = 3, LevelSelect = 4}
export(SelectMenuList) var NextMenuScene = SelectMenuList.MainMenu
var NextMenuSceneIsNow
export(SelectMenuList) var WhereMenuIsNow = SelectMenuList.MainMenu
enum DialogConfirmsFor {Nothing = 0, ChangeDVD = 1, QuitGame = 2, LeaveLevel = 3}
export(DialogConfirmsFor) var DialogSelectAction
export(NodePath) var MainMenuNode
export(NodePath) var NextMenuNode
export(NodePath) var GameplayUINode
export(bool) var ReadyToPlayGame = false
export(bool) var isPlayingGameNow = false
export(bool) var isPausingGame = false
export(bool) var isMainMenuing = true
export(bool) var isNextMenuing = false

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
	$GameplayUI.hide()
	isNextMenuing = true
	pass

func SetAndShowNextMenu(WhichMenu):
	NextMenuScene = WhichMenu
	$NextMenu.SetYourMenuList(WhichMenu)
	ShowNextMenu()
	pass

func ReturnToMenuNow():
	WhereMenuIsNow = SelectMenuList.MainMenu
	pass

func BackToMainMenu():
	$GameplayUI.hide()
	$NextMenu.hide()
	$MainMenu.show()
	$MainMenu.ArriveAtMainMenu()
	isMainMenuing = true
	pass

func SetReadyToPlay(isItReady):
	ReadyToPlayGame = isItReady
	pass

func SetIsPlayingGameNow(isItPlaying):
	isPlayingGameNow = isItPlaying
	pass

func ShowGameplayUI():
	#print("Show gameplay HUD UI")
	#SetAndShowNextMenu(SelectMenuList.Gameplay)
	$GameplayUI.show()
	$NextMenu.hide()
	$MainMenu.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_0):
		#NextMenu(PassMenuScene)
		#ShowNextMenu()
		pass
	
	
	if WhereMenuIsNow == SelectMenuList.MainMenu:
		if not isMainMenuing:
			BackToMainMenu()
			isMainMenuing = true
			isNextMenuing = false
			pass
		pass
	elif WhereMenuIsNow == SelectMenuList.Setting:
		if not isNextMenuing:
			SetAndShowNextMenu(SelectMenuList.Setting)
			pass
		pass
	elif WhereMenuIsNow == SelectMenuList.Unknown:
		if not isNextMenuing:
			SetAndShowNextMenu(SelectMenuList.Unknown)
			pass
		pass
	elif WhereMenuIsNow == SelectMenuList.Extras:
		if not isNextMenuing:
			SetAndShowNextMenu(SelectMenuList.Extras)
			pass
		pass
	elif WhereMenuIsNow == SelectMenuList.LevelSelect:
		if not isNextMenuing:
			print("Grimp")
			SetAndShowNextMenu(SelectMenuList.LevelSelect)
			pass
		pass
	elif WhereMenuIsNow == SelectMenuList.Gameplay:
		if ReadyToPlayGame:
			#print("Readygame")
			if not $GameplayUI.visible:
				print("Show UI Gameplay")
				ShowGameplayUI()
				pass
			pass
		else:
			if not isNextMenuing:
				#ShowNextMenu()
				SetAndShowNextMenu(SelectMenuList.Gameplay)
				pass
			pass
		pass
	pass
	
	if not WhereMenuIsNow == SelectMenuList.MainMenu:
		isMainMenuing = false
		pass

func SpecialPlayButtonHeurestic():
	print("The Play Button")
	if isPlayingGameNow:
		print("Unpause Game")
		WhereMenuIsNow = SelectMenuList.Gameplay
	else:
		print("Select your Level")
		WhereMenuIsNow = SelectMenuList.LevelSelect
		pass
	pass

func SpecialExitButtonHeurestic():
	print("The Exit Button")
	if isPlayingGameNow:
		AttemptTheLeaveGame()
		pass
	else:
		AttempTheQuitGame()
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
	elif WhichContext == DialogConfirmsFor.LeaveLevel:
		$AreYouSureDialog.SpawnDialogWithAppendSure("leave this level")
		pass
	pass

signal PleaseLeaveTheGame()
func DoDialogYesButtonOf():
	print("Dialog Yes Button")
	#FocusPlayButtonNow()
	CloseTheDrawer()
	if DialogSelectAction == DialogConfirmsFor.Nothing:
		
		pass
	elif DialogSelectAction == DialogConfirmsFor.ChangeDVD:
		ChangeTheDVDNow()
		pass
	elif DialogSelectAction == DialogConfirmsFor.QuitGame:
		#get_tree().quit()
		ExecuteShutdown()
		pass
	elif DialogSelectAction == DialogConfirmsFor.LeaveLevel:
		ExecuteLeaveLevel()
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


func AttemptTheLeaveGame():
	#emit_signal("PleaseLeaveTheGame")
	if $AreYouSureDialog.isSpawned:
		$AreYouSureDialog.NoCancel()
		pass
	else:
		SetSpawnDialogContextFor(DialogConfirmsFor.LeaveLevel)
		pass
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

func ExecuteLeaveLevel():
	emit_signal("PleaseLeaveTheGame")
	isPlayingGameNow = false
	ReadyToPlayGame = false
	isMainMenuing = true
	isNextMenuing = false
	pass

func _on_BackButton_pressed(extra_arg_0):
	BackToMainMenu()
	pass # Replace with function body.


func _on_MainMenu_PressChangeDVD():
	AttemptTheChangeDVD()
	pass # Replace with function body.


func _on_MainMenu_PressExit():
	SpecialExitButtonHeurestic()
	pass # Replace with function body.


func _on_MainMenu_PressExtras():
	
	WhereMenuIsNow = SelectMenuList.Extras
	pass # Replace with function body.


func _on_MainMenu_PressPlay():
	SpecialPlayButtonHeurestic()
	pass # Replace with function body.


func _on_MainMenu_PressSetting():
	
	WhereMenuIsNow = SelectMenuList.Setting
	pass # Replace with function body.


func _on_MainMenu_PressUnknown():
	
	WhereMenuIsNow = SelectMenuList.Unknown
	pass # Replace with function body.

func _on_NextMenu_PressBackButton():
	#BackToMainMenu()
	ReturnToMenuNow()
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

func ManageLoading(ProgressValuei = 0, WordingHint = "Loadinger", isComplete = false):
	$LoadingPopup.ManageLoading(ProgressValuei, WordingHint, isComplete)
	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
func _on_NextMenu_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	WhereMenuIsNow = SelectMenuList.Gameplay
	emit_signal("PleaseLoadThisLevelOf", a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass # Replace with function body.


func _on_GameplayUI_PressPauseButton():
	WhereMenuIsNow = SelectMenuList.MainMenu
	pass # Replace with function body.


func _on_NextMenu_GetYourMenuList(whichOf):
	NextMenuSceneIsNow = whichOf
	pass # Replace with function body.
