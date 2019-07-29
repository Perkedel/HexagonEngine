extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Hexagon Engine is like Java but it's Godot. interpreted software! actualy no. it's sub-games inside this
# fantasy console
enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
export(MenuLists) var MenuIsRightNow = 0
export var isPlayingTheGameNow = false
export var PauseTheGame = false

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func NextMenu():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

# Place UIspace under CanvasLayer! https://godotengine.org/qa/396/gui-not-following-camera

signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ExecuteChangeDVD():
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
	emit_signal("Shutdown_Exec")
	pass

func _on_UIspace_ChangeDVD_Exec():
	ExecuteChangeDVD()
	pass # Replace with function body.

func _on_UIspace_Shutdown_Exec():
	ExecuteShutdown()
	pass # Replace with function body.

func ManageLoadingBar():
	pass

func ExecuteLoadLevel():
	
	pass

# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html
func ThreadLoadLevel(aVariable): #Execute in Thread!
	
	pass

# https://docs.godotengine.org/en/3.1/tutorials/threads/using_multiple_threads.html
func goto_scene(a3Dpath, a2Dpath):
	aThread.
	
	$MustFollowPersonCamera2D/UIspace.SpawnLoadingBar()
	pass

func ReceiveLoadClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	Your3DSpaceLevel = a3DScapePacked
	Your2DSpaceLevel = a2DSpacePacked
	LevelBannerThumbnail = LevelThumb
	LevelTitleg = LevelTitle
	LevelDescription = LevelDesc
	#ExecuteThreadLoadLevel here
	
	pass

# FInal chain! please save variable and do loading stuffs!
func _on_UIspace_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	ReceiveLoadClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass # Replace with function body.
