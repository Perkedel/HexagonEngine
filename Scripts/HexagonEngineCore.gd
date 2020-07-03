extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Function and variables are now on Template
#enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
#export(MenuLists) var MenuIsRightNow = 0
#export var isPlayingTheGameNow = false
#export var PauseTheGame = false
#var ConThread
onready var isRunningDVD = true
onready var preloadDVD = 0
onready var doPreloadDVD = false
export(PackedScene) var LoadDVD 
#enum ListOfDVDsTemporarily {Template, AdmobTestoid}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _exit_tree():
	pass

func DoLaunchTheDVD():
	
	pass

func JustRemoveDVDThatsIt():
	$DVDCartridgeSlot.ExecuteRemoveAllDVDs()
	pass


func DoChangeDVDNow():
	print("Change DVD!")
	Singletoner.ResumeGameNow()
	#$DVDCartridgeSlot.get_child(0).queue_free() #queue_free() leaves traces and may cause memory leak!
	# Ah peck! free() error, attempted to free locked object
	#$MetaMenu/ChangeDVDMenu.show()
	$MetaMenu/ChangeDVDMenu.ShowMeSelf()
	#$DVDCartridgeSlot.get_child(0).free()
	pass

func PatchedChangeDVDNow():
	LoadDVD = "res://GameDVDCardtridge/ChangeDVDv3/bootThis.tscn"
	$DVDCartridgeSlot.PlayDVD(LoadDVD)
	pass

func DoShutdownNow():
	# https://godotengine.org/qa/554/is-there-a-way-to-close-a-game-using-gdscript
	JustRemoveDVDThatsIt()
	Singletoner.Nonaktifkan_Sistem()
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
	print("Receive DVD Click Index No. " + String(Index))
	match Index:
		0:
			LoadDVD = load("res://GameDVDCardtridge/TemplateHexagonEngine/TemplateHexagonEngine.tscn")
			pass
		1:
			LoadDVD = load("res://GameDVDCardtridge/AdmobberTestio/AdmobberTestio.tscn")
			pass
		2:
			LoadDVD = load("res://GameDVDCardtridge/ParlorClassic/Parlor.tscn")
			pass
		3:
			LoadDVD = load("res://GameDVDCardtridge/IsengHedBoll/IsengModeHeddBoll.tscn")
			pass
		4:
			LoadDVD = load("res://GameDVDCardtridge/YoneMIDIArea_Prosotipe/YoneMIDIarea.tscn")
			pass
		5: 
			LoadDVD = load("res://GameDVDCardtridge/404/404.tscn")
			pass
		6:
			LoadDVD = load("res://GameDVDCardtridge/BolaAccelerometer/BolaAccelerometer.tscn")
			pass
		7:
			LoadDVD = load("res://GameDVDCardtridge/Splitscrin/Splitscrin Taris.tscn")
			pass
		8:
			LoadDVD = load("res://GameDVDCardtridge/ChangeDVDv3/ChangeDVDv3.tscn")
			pass
		9:
			LoadDVD = load("res://GameDVDCardtridge/ManOfCoyote/ManOfCoyote.tscn")
			pass
		10:
			LoadDVD = load("res://GameDVDCardtridge/DetakJantungProsotipe/DetakJantungProsotipe.tscn")
			pass
		_:
			LoadDVD = load("res://GameDVDCardtridge/404/404.tscn")
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

# Fenix Github Integration asset lib


func _on_DVDCartridgeSlot_NoDisc():
	DoChangeDVDNow()
	pass # Replace with function body.
