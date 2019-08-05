extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Hexagon Engine is like Java but it's Godot. interpreted software! actualy no. it's sub-games inside this
# fantasy console
enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
export(MenuLists) var MenuIsRightNow = 0
export(bool) var isPlayingTheGameNow = false
export(bool) var LoadingHasCompleted
export(bool) var PauseTheGame = false

# https://www.youtube.com/watch?v=9sHKaQBcgO8&t=14s
# https://www.youtube.com/watch?v=-x0M17IwG0s
onready var aThread = Thread.new()


export(float) var loadValue
export(PackedScene) var Your3DSpaceLevel
var Prev3DSpaceLevel
export(PackedScene) var Your2DSpaceLevel
var Prev2DSpaceLevel
export(Texture) var LevelBannerThumbnail
export(String) var LevelTitleg
# https://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#exports
export(String, MULTILINE) var LevelDescription

var Sub3DLoadValue
var Sub3DLoadInclude = false
var Sub3DLoadCompleted = false
var Sub2DLoadValue
var Sub2DLoadInclude = false
var Sub2DLoadCompleted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func NextMenu():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	$MustFollowPersonCamera2D/UIspace.SetReadyToPlay(LoadingHasCompleted)
	$MustFollowPersonCamera2D/UIspace.SetIsPlayingGameNow(isPlayingTheGameNow)
	if LoadingHasCompleted:
		
		pass
	
	$MustFollowPersonCamera2D/UIspace.ManageLoading(loadValue, LevelTitleg, LoadingHasCompleted)
	pass

# Place UIspace under CanvasLayer! https://godotengine.org/qa/396/gui-not-following-camera

signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ExecuteChangeDVD():
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
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
	
	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
	isPlayingTheGameNow = true
	#$MustFollowPersonCamera2D/UIspace.SetIsPlayingGameNow(true)
	pass

func leave_scene():
	$"3Dspace".despawnTheScene()
	$"2Dspace".despawnTheScene()
	isPlayingTheGameNow = false
	#$MustFollowPersonCamera2D/UIspace.SetIsPlayingGameNow(false)
	pass

func ReceiveLoadClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
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
	ExecuteUnloadLevel()
	pass

# FInal chain! please save variable and do loading stuffs!
func _on_UIspace_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	isPlayingTheGameNow = true
	LoadingHasCompleted = false
	ReceiveLoadClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	#print("TemplateHexagonEngine Received SignalCLick %s %s", a3DScapePacked, a2DSpacePacked)
	pass # Replace with function body.

func _on_3Dspace_IncludeMeForYourLoading(MayI):
	Sub3DLoadInclude = MayI
	pass # Replace with function body.


func _on_3Dspace_a3D_Loading_ProgressBar(valuet):
	Sub3DLoadValue = valuet
	print("Load Value ", valuet)
	#loadValue = valuet
	pass # Replace with function body.


func _on_3Dspace_hasLoadingCompleted():
	Sub3DLoadCompleted = true
	pass # Replace with function body.


func _on_2Dspace_IncludeMeForYourLoading(MayI):
	Sub2DLoadInclude = MayI
	pass # Replace with function body.


func _on_2Dspace_a2D_Loading_ProgressBar(valuet):
	Sub2DLoadValue = valuet
	pass # Replace with function body.


func _on_2Dspace_hasLoadingCompleted():
	Sub2DLoadCompleted = true
	pass # Replace with function body.



