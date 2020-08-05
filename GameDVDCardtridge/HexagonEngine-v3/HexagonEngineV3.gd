extends Node

onready var LevelSpace = $LevelSpace
onready var UIplace = $UICanvas/UIplace
export(PackedScene) var PauseMainMenuFile
export(PackedScene) var GameplayHUDMenuFile
export(PackedScene) var JustPauseMenuFile
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()
enum CanvasLayerMode {Usual = 1, Priority = 10}


func SaveEverythingFirst():
	Kixlonzing.SaveKixlonz()
	Settingers.SettingSave()

func ChangeTheDVDnow():
	print("Change Da DVD")
	SaveEverythingFirst()
	emit_signal("ChangeDVD_Exec")

func ShutdownHexagonEngineNow():
	print("Shutdown da Hexagon Engine")
	SaveEverythingFirst()
	emit_signal("Shutdown_Exec")

# Called when the node enters the scene tree for the first time.
func _ready():
	if PauseMainMenuFile:
		UIplace.preloadPauseMainMenu(PauseMainMenuFile)
	if GameplayHUDMenuFile:
		UIplace.preloadGameplayHUDMenu(GameplayHUDMenuFile)
	if JustPauseMenuFile:
		UIplace.preloadJustPauseMenu(JustPauseMenuFile)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
