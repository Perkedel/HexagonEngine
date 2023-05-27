extends Node

#class_name TemplateHexagonEngine, "res://Sprites/HexagonEngineSymbol.png"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Hexagon Engine is like Java but it's Godot. interpreted software! actualy no. it's sub-games inside this
# fantasy console
# TODO v3: Emmerge 2D and 3D into just one loading slot!
signal ChangeDVD_Exec()
signal Shutdown_Exec()
enum CanvasLayerMode {Usual = 1, Priority = 10}

enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
@export var MenuIsRightNow: MenuLists = 0
@export var isPlayingTheGameNow: bool = false
@export var LoadingHasCompleted: bool
@export var PauseTheGame: bool = false
#export (bool) var isGamePaused = false

@export var ExitGameName: String = "Exit"
@export var LeaveLevelName: String = "Leave Level"

# https://www.youtube.com/watch?v=9sHKaQBcgO8&t=14s
# https://www.youtube.com/watch?v=-x0M17IwG0s
@onready var aThread = Thread.new()


@export var loadValue: float
@export var Your3DSpaceLevel: PackedScene
var Prev3DSpaceLevel
@export var Your2DSpaceLevel: PackedScene
var Prev2DSpaceLevel
@export var LevelBannerThumbnail: Texture2D
@export var LevelTitleg: String
# https://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#exports
@export var LevelDescription # (String, MULTILINE)

#Stop here. Pls manage Status HUD Bar now!
@export var a2DSpaceReportHP: bool = false
@export var a3DSpaceReportHP: bool = false
@export var a2DSpaceReportScore: bool = false
@export var a3DSpaceReportScore: bool = false

@export (float) var See3DHP = 100
@export (float) var See2DHP = 100
@export (float) var See3DScore = 0
@export (float) var See2DScore = 0

@export (float) var emitHP = 100
@export (float) var emitScore = 2000
@export (Texture2D) var emitScoreIcon

var Sub3DLoadValue
var Sub3DLoadInclude = false
var Sub3DLoadCompleted = false
var Sub2DLoadValue
var Sub2DLoadInclude = false
var Sub2DLoadCompleted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	PrepareHUD()
	pass # Replace with function body.

func _exit_tree():
	#free()
	pass

func _input(event):
	if isPlayingTheGameNow:
		pass
	else:
		
		pass
	pass

func LoadJustNow(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
	isPlayingTheGameNow = true
	LoadingHasCompleted = false
	ReceiveLoadClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass

func AlsoConnectSignalJustNow(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore):
	a2DSpaceReportHP = a2DSpaceHP
	a3DSpaceReportHP = a3DSpaceHP
	a2DSpaceReportScore = a2DSpaceScore
	a3DSpaceReportScore = a3DSpaceScore
	
	print("Set Statuso Flag")
	pass

func SetPauseYes():
	$MustFollowPersonCamera2D/UIspace.PauseMenu()
	PauseTheGameNow()
	pass
func SetPauseNo():
	$MustFollowPersonCamera2D/UIspace.ResumeMenu()
	ResumeTheGameNow()
	pass

func PressPauseButton():
	if isPlayingTheGameNow:
		if !PauseTheGame:
			SetPauseYes()
			pass
		else:
			SetPauseNo()
			pass
		pass
	#PauseTheGame = !PauseTheGame
	pass

func TheLitteralPlayButton():
	if isPlayingTheGameNow:
		ResumeTheGameNow()
		pass
	else:
		pass
	pass

func PauseTheGameNow():
	PauseTheGame = true
	print("Pause the game")
	get_tree().paused = true
	pass

func ResumeTheGameNow():
	PauseTheGame = false
	print("Resume The Game")
	get_tree().paused = false
	pass

# HUD manage
func PrepareHUD():
	# 2x2 Statement Grid = 2 Spaces (2D & 3D) x 2 Options (YES & NO)
#	if a2DSpaceReportHP and a3DSpaceReportHP:
#
#		pass
#	elif not a2DSpaceReportHP and a3DSpaceReportHP:
#
#		pass
#	elif a2DSpaceReportHP and not a3DSpaceReportHP:
#
#		pass
#	elif not a2DSpaceReportHP and not a3DSpaceReportHP:
#		pass
#
#
#	if a2DSpaceReportScore and a3DSpaceReportScore:
#
#		pass
#	elif not a2DSpaceReportScore and a3DSpaceReportScore:
#
#		pass
#	elif a2DSpaceReportScore and not a3DSpaceReportScore:
#
#		pass
#	elif not a2DSpaceReportScore and not a3DSpaceReportScore:
#
#		pass
	
	if a2DSpaceReportHP:
		
		pass
	if a3DSpaceReportHP:
		
		pass
	
	if a2DSpaceReportScore:
		
		pass
	if a3DSpaceReportScore:
		
		pass
	pass
func ManageHUD():
	# 2x2 Statement Grid = 2 Spaces (2D & 3D) x 2 Options (YES & NO)
	if a2DSpaceReportHP and a3DSpaceReportHP:
		emitHP = clamp((See2DHP+See3DHP)/2, 0, 100)
		pass
	elif not a2DSpaceReportHP and a3DSpaceReportHP:
		emitHP = clamp((See3DHP), 0, 100)
		pass
	elif a2DSpaceReportHP and not a3DSpaceReportHP:
		emitHP = clamp((See2DHP), 0, 100)
		pass
	elif not a2DSpaceReportHP and not a3DSpaceReportHP:
		emitHP = 100
		pass
	
	
	if a2DSpaceReportScore and a3DSpaceReportScore:
		emitScore = See2DScore + See3DScore
		pass
	elif not a2DSpaceReportScore and a3DSpaceReportScore:
		emitScore = See3DScore
		pass
	elif a2DSpaceReportScore and not a3DSpaceReportScore:
		emitScore = See2DScore
		pass
	elif not a2DSpaceReportScore and not a3DSpaceReportScore:
		emitScore = 10000
		pass
		
	$MustFollowPersonCamera2D/UIspace.HPlevel = emitHP
	$MustFollowPersonCamera2D/UIspace.ScoreIcon = emitScoreIcon
	$MustFollowPersonCamera2D/UIspace.ScoreNumber = emitScore
	pass
# End Manage HUD

func SetExitButtonLabel(name:String):
	$MustFollowPersonCamera2D/UIspace.SetExitButtonLabel(name)
	pass

func NextMenu():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ManageHUD()
	if Sub3DLoadInclude and Sub2DLoadInclude:
		loadValue = (Sub3DLoadValue + Sub2DLoadValue)/2
		pass
	elif Sub3DLoadInclude and not Sub2DLoadInclude:
		loadValue = (Sub3DLoadValue)
		pass
	elif not Sub3DLoadInclude and Sub2DLoadInclude:
		loadValue = (Sub2DLoadValue)
		pass
	else:
		pass
	
	if Sub3DLoadCompleted and Sub2DLoadCompleted:
		LoadingHasCompleted = true
		pass
	
	Singletoner.isPlayingGameNow = isPlayingTheGameNow
	Singletoner.isGamePaused = PauseTheGame
	$MustFollowPersonCamera2D/UIspace.SetReadyToPlay(LoadingHasCompleted)
	$MustFollowPersonCamera2D/UIspace.SetIsPlayingGameNow(isPlayingTheGameNow)
	if LoadingHasCompleted:
		
		pass
	
	$MustFollowPersonCamera2D/UIspace.ManageLoading(loadValue, LevelTitleg, LoadingHasCompleted)
	
	if isPlayingTheGameNow:
		SetExitButtonLabel(LeaveLevelName)
		pass
	else:
		SetExitButtonLabel(ExitGameName)
		
		pass
	
	if Input.is_key_pressed(KEY_BACK) or Input.is_action_just_pressed("EscapeButton"):
		#emit_signal("PressExit") # Exit Pressing
		$MustFollowPersonCamera2D/UIspace.PressEscapeButton()
		
		
		pass
	pass

# Place UIspace under CanvasLayer! https://godotengine.org/qa/396/gui-not-following-camera



func ExecuteChangeDVD():
	ResumeTheGameNow()
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
	ResumeTheGameNow()
	print("aDVD sent Shutdown")
	emit_signal("Shutdown_Exec")
	pass

func _on_UIspace_PleaseLeaveTheGame():
	ReceiveUnloadClick()
	pass # Replace with function body.

func _on_UIspace_ChangeDVD_Exec():
	ExecuteChangeDVD()
	pass # Replace with function body.

func _on_UIspace_Shutdown_Exec():
	ExecuteShutdown()
	pass # Replace with function body.

func ManageLoadingBar():
	pass

func ExecuteLoadLevel():
	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
	goto_scene(Your3DSpaceLevel,Your2DSpaceLevel)
	pass

func ExecuteUnloadLevel():
	leave_scene()
	pass

# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html
func ThreadLoadLevel(aVariable): #Execute in Thread!
	
	pass

# https://docs.godotengine.org/en/3.1/tutorials/threads/using_multiple_threads.html
func goto_scene(a3Dpath, a2Dpath):
	#$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
	Sub2DLoadCompleted = false
	Sub3DLoadCompleted = false
	Sub2DLoadValue = 0
	Sub3DLoadValue = 0
	Sub2DLoadInclude = false
	Sub3DLoadInclude = false
	$"3Dspace".spawnAScene(a3Dpath)
	#$"3Dspace".ThreadingSpawnScene(a3Dpath)
	$"2Dspace".spawnAScene(a2Dpath)
	#$"2Dspace".ThreadingSpawnScene(a2Dpath)
	isPlayingTheGameNow = true
	#$MustFollowPersonCamera2D/UIspace.SetIsPlayingGameNow(true)
	pass

func leave_scene():
	$"3Dspace".DisconnecStatusSignal()
	$"2Dspace".DisconnecStatusSignal()
	$"3Dspace".despawnTheScene()
	$"2Dspace".despawnTheScene()
	isPlayingTheGameNow = false
	#$MustFollowPersonCamera2D/UIspace.SetIsPlayingGameNow(false)
	pass

func ReceiveLoadClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
	Your3DSpaceLevel = a3DScapePacked
	Your2DSpaceLevel = a2DSpacePacked
	LevelBannerThumbnail = LevelThumb
	LevelTitleg = LevelTitle
	LevelDescription = LevelDesc
	
	print(Your3DSpaceLevel)
	#ExecuteThreadLoadLevel here
	ExecuteLoadLevel()
	pass

func ReceiveUnloadClick():
	ResumeTheGameNow()
	ExecuteUnloadLevel()
	pass

# FInal chain! please save variable and do loading stuffs!
func _on_UIspace_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	LoadJustNow(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass # Replace with function body.

func _on_3Dspace_IncludeMeForYourLoading(MayI):
	Sub3DLoadInclude = MayI
	pass # Replace with function body.


func _on_3Dspace_a3D_Loading_ProgressBar(valuet):
	Sub3DLoadValue = valuet
	#print("Load Value ", valuet)
	#loadValue = valuet
	pass # Replace with function body.


func _on_3Dspace_hasLoadingCompleted():
	Sub3DLoadCompleted = true
	#$"3Dspace".ConnecStatusSignal()
	pass # Replace with function body.


func _on_2Dspace_IncludeMeForYourLoading(MayI):
	Sub2DLoadInclude = MayI
	
	pass # Replace with function body.


func _on_2Dspace_a2D_Loading_ProgressBar(valuet):
	Sub2DLoadValue = valuet
	pass # Replace with function body.


func _on_2Dspace_hasLoadingCompleted():
	Sub2DLoadCompleted = true
	#$"2Dspace".ConnecStatusSignal()
	pass # Replace with function body.

func _on_UIspace_PlayButtonLayerSpec(selecte):
	#$MustFollowPersonCamera2D.layer = selecte
	#print("Set Main UI Layer = " + String(selecte))
	pass # Replace with function body.


func _on_UIspace_PressPauseButton():
	#PressPauseButton()
	SetPauseYes()
	pass # Replace with function body.


func _on_UIspace_LitteralPlayButton():
	TheLitteralPlayButton()
	pass # Replace with function body.


func _on_UIspace_IPressedEscapeOnPlayingGame():
	PressPauseButton()
	print("\n + Press Pause UI Space + \n")
	pass # Replace with function body.

#signal AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
func _on_UIspace_AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore):
	AlsoConnectSignalJustNow(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
	pass # Replace with function body.


func _on_3Dspace_TellHP(Level):
	See3DHP = Level
	pass # Replace with function body.


func _on_2Dspace_TellHP(Level):
	See2DHP = Level
	pass # Replace with function body.


func _on_3Dspace_TellScore(value):
	See3DScore = value
	pass # Replace with function body.


func _on_2Dspace_TellScore(value):
	See2DScore = value
	pass # Replace with function body.


func _on_3Dspace_readyToPlayNow():
	$"3Dspace".ConnecStatusSignal()
	pass # Replace with function body.


func _on_2Dspace_readyToPlayNow():
	$"2Dspace".ConnecStatusSignal()
	pass # Replace with function body.

var LevelCard = {
	
}

func _on_3Dspace_TellLevelCard(path):
#	ReceiveUnloadClick()
#	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
#	isPlayingTheGameNow = true
#	LoadingHasCompleted = false
#
	pass # Replace with function body.

# artg sphaghetti code plns remake!
func _on_2Dspace_TellLevelCard(path):
#	ReceiveUnloadClick()
#	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
#	isPlayingTheGameNow = true
#	LoadingHasCompleted = false
	pass # Replace with function body.
