extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Function and variables are now on Template
#enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
#export(MenuLists) var MenuIsRightNow = 0
#export var isPlayingTheGameNow = false
#export var PauseTheGame = false
var ConThread
export var isRunningDVD = true
export var preloadDVD = 0
export(PackedScene) var LoadDVD 
enum ListOfDVDsTemporarily {Template, AdmobTestoid}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func DoLaunchTheDVD():
	
	pass

func DoChangeDVDNow():
	print("Change DVD!")
	$DVDCartridgeSlot.get_child(0).queue_free()
	#$MetaMenu/ChangeDVDMenu.show()
	$MetaMenu/ChangeDVDMenu.ShowMeSelf()
	pass

func DoShutdownNow():
	# https://godotengine.org/qa/554/is-there-a-way-to-close-a-game-using-gdscript
	Kixlonzing.SaveKixlonz()
	print("Quit Game!")
	get_tree().quit()
	pass

func _on_DVDCartridgeSlot_ChangeDVD_Exec():
	DoChangeDVDNow()
	pass # Replace with function body.


func _on_DVDCartridgeSlot_Shutdown_Exec():
	DoShutdownNow()
	pass # Replace with function body.


func _on_ChangeDVDMenu_ShutdownHexagonEngineNow():
	DoShutdownNow()
	pass # Replace with function body.


func _on_ChangeDVDMenu_ItemClickEnter(Index):
	if Index == 0:
		LoadDVD = load("res://GameDVDCardtridge/TemplateHexagonEngine/TemplateHexagonEngine.tscn")
		pass
	if Index == 1:
		LoadDVD = load("res://GameDVDCardtridge/AdmobberTestio/AdmobberTestio.tscn")
		pass
	if Index == 2:
		LoadDVD = load("res://GameDVDCardtridge/ParlorClassic/Parlor.tscn")
		pass
	else:
		pass
	$DVDCartridgeSlot.PlayDVD(LoadDVD)
	pass # Replace with function body.


func _on_DVDCartridgeSlot_DVDTryLoad():
	print("DVD has tried to load!")
	$MetaMenu/ChangeDVDMenu.hide()
	pass # Replace with function body.

# https://github.com/electron/rcedit/releases
# To edit .exe resources. insert it in the godot editor setting!
# Editor, Setting, Export, Windows, rcedit, refer that rcedit exe file
