extends Node

@export_subgroup('Main Navigation')
@onready var LevelSpace = $LevelSpace
@onready var UIplace = $UICanvas/UIplace
@onready var LevelSpacer = $LevelSpace
@export var PauseMainMenuFile: PackedScene
@export var GameplayHUDMenuFile: PackedScene
@export var JustPauseMenuFile: PackedScene
@export var InitLevelFile:PackedScene

@export_subgroup('Sub Navigation')
@export var SettingMenuFile:PackedScene

@export_subgroup('Startup')
@export var StartFromGameHUD: bool = true
@export_enum('MainMenu','Gameplay') var StartFromWhere:String = 'MainMenu'
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levelInstance:Node

signal ChangeDVD_Exec()
signal Shutdown_Exec()
enum CanvasLayerMode {Usual = 1, Priority = 10}

func SaveEverythingFirst():
	Kixlonzing.SaveKixlonz()
	Settingers.SettingSave()

func ChangeTheDVDnow():
	print("Change Da DVD")
	SaveEverythingFirst()
	Singletoner.changeDVD()
	#emit_signal("ChangeDVD_Exec")

func ShutdownHexagonEngineNow():
	print("Shutdown da Hexagon Engine")
	SaveEverythingFirst()
	Singletoner.shutdownNow()
	#emit_signal("Shutdown_Exec")

func loadLevel(ofThis:PackedScene)->Node:
	levelInstance = ofThis.instantiate()
	LevelSpacer.add_child(levelInstance)
	return levelInstance
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if PauseMainMenuFile:
		UIplace.preloadPauseMainMenu(PauseMainMenuFile)
	if GameplayHUDMenuFile:
		UIplace.preloadGameplayHUDMenu(GameplayHUDMenuFile)
	if JustPauseMenuFile:
		UIplace.preloadJustPauseMenu(JustPauseMenuFile)
	if InitLevelFile:
		loadLevel(InitLevelFile)
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pressAMenuButton(whichIs:String,Argument:String):
	#print('Menu Press: ' + whichIs + ' ' + Argument)
	match(whichIs):
		'Play':
			#print('Playe')
			pass
		'Options':
			pass
		'Extras':
			pass
		'Exit':
			print('exit')
			UIplace.changePauseMainMenuNavigator(1)
			pass
		'Shutdown':
			ShutdownHexagonEngineNow()
		'ChangeDVD':
			ChangeTheDVDnow()
			pass
		'CancelQuit':
			print('Cancel Quit')
			UIplace.changePauseMainMenuNavigator(0)
		_:
			pass
	pass

func _on_AreYouSureDialog_NoImNotSure():
	pass # Replace with function body.


func _on_AreYouSureDialog_YesImSure():
	pass # Replace with function body.


func _on_UIplace_doChangeDVD():
	ChangeTheDVDnow()
	pass # Replace with function body.


func _on_UIplace_doShutdown():
	ShutdownHexagonEngineNow()
	pass # Replace with function body.
