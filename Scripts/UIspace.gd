extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"
enum SelectMenuList {MainMenu=-1, Setting=0,Unknown=1,Extras=2, Gameplay = 3, LevelSelect = 4}
@export var NextMenuScene: SelectMenuList = SelectMenuList.MainMenu
var NextMenuSceneIsNow
@export var WhereMenuIsNow: SelectMenuList = SelectMenuList.MainMenu
enum DialogConfirmsFor {Nothing = 0, ChangeDVD = 1, QuitGame = 2, LeaveLevel = 3}
@export var DialogSelectAction: DialogConfirmsFor
@export var MainMenuNode: NodePath
@export var NextMenuNode: NodePath
@export var GameplayUINode: NodePath
@export var ReadyToPlayGame: bool = false
@export var isPlayingGameNow: bool = false
@export var isPausingGame: bool = false
@export var isMainMenuing: bool = true
@export var isNextMenuing: bool = false

@export var a2DSpaceReportHP: bool = false
@export var a3DSpaceReportHP: bool = false
@export var a2DSpaceReportScore: bool = false
@export var a3DSpaceReportScore: bool = false

@export (float, 0, 100) var HPlevel = 100
@export (Texture2D) var ScoreIcon
@export (float) var ScoreNumber = 2000

@export var KeepPlayingEvenOutOfFocus: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenu/VBoxContainer/MenuButtonings/FocusArea/SamPlayArea/PlayButton.grab_focus()
	#FocusPlayButtonNow()
	CloseTheDrawer()
	pass # Replace with function body.

signal IPressedEscapeOnPlayingGame()
func PressEscapeButton():
	if isPlayingGameNow:
		emit_signal("IPressedEscapeOnPlayingGame")
		
		pass
	else:
		SpecialExitButtonHeurestic()
		pass
	pass

func SetExitButtonLabel(name:String):
	$MainMenu.SetExitButtonLabel(name)
	pass

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
	emit_signal("PlayButtonLayerSpec",10)
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
	emit_signal("PlayButtonLayerSpec", 1)
	pass

func ManageHUD():
	$GameplayUI.HPlevel = HPlevel
	$GameplayUI.ScoreIcon = ScoreIcon
	$GameplayUI.ScoreNumber = ScoreNumber
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ManageHUD()
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

signal PlayButtonLayerSpec(selecte)
signal LitteralPlayButton
func SpecialPlayButtonHeurestic():
	emit_signal("LitteralPlayButton")
	print("The Play Button")
	if isPlayingGameNow:
		print("Unpause Game")
		WhereMenuIsNow = SelectMenuList.Gameplay
	else:
		print("Select your Level")
		WhereMenuIsNow = SelectMenuList.LevelSelect
		pass
	pass

func PauseMenu():
	WhereMenuIsNow = SelectMenuList.MainMenu
	pass

func ResumeMenu():
	WhereMenuIsNow = SelectMenuList.Gameplay
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
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT && OS.get_name().nocasecmp_to("windows") != 0:
		if isPlayingGameNow and not KeepPlayingEvenOutOfFocus:
			#  https://docs.godotengine.org/en/3.2/tutorials/inputs/inputevent.html
			# https://docs.godotengine.org/en/3.2/classes/class_inputeventkey.html#class-inputeventkey
			# https://docs.godotengine.org/en/3.2/classes/class_@globalscope.html#enum-globalscope-keylist
			# https://docs.godotengine.org/en/3.2/classes/class_@globalscope.html#enum-globalscope-keylist
			if not Input.is_key_pressed(KEY_PRINT) or not Input.is_key_pressed(KEY_SYSREQ):
				emit_signal("PressPauseButton")
				pass
			pass
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
	
	if event.is_action_pressed("DaftarPauso"):
		#emit_signal("PressPauseButton")
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
	print("Main menu Press Exit")
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

func ManageLoading(ProgressValuei:float = 0, WordingHint = "Loadinger", isComplete = false):
	$LoadingPopup.ManageLoading(ProgressValuei, WordingHint, isComplete)
	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)

func _on_NextMenu_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	WhereMenuIsNow = SelectMenuList.Gameplay
	emit_signal("PleaseLoadThisLevelOf", a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass # Replace with function body.


signal PressPauseButton
func _on_GameplayUI_PressPauseButton():
	#PauseMenu()
	emit_signal("PressPauseButton")
	print("Press Pause Now")
	pass # Replace with function body.


func _on_NextMenu_GetYourMenuList(whichOf):
	NextMenuSceneIsNow = whichOf
	pass # Replace with function body.

signal AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
func _on_NextMenu_AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore):
	a2DSpaceReportHP = a2DSpaceHP
	a3DSpaceReportHP = a3DSpaceHP
	a2DSpaceReportScore = a2DSpaceScore
	a3DSpaceReportScore = a3DSpaceScore
	emit_signal("AlsoPlsConnectThisReportStatus",a3DSpaceReportHP,a2DSpaceReportHP,a3DSpaceReportScore,a2DSpaceReportScore)
	pass # Replace with function body.


func _on_NextMenu_canThisLevelPlayEvenOutOfFocus(mayI):
	KeepPlayingEvenOutOfFocus = mayI
	pass # Replace with function body.
