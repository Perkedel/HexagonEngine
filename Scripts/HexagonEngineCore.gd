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
onready var zetrixViewport = $ZetrixViewport
onready var changeDVDMenu = $MetaMenu/ChangeDVDMenu
onready var zetrixPreview = $MetaMenu/JustZetrixVRViewer
onready var dvdSlot = $DVDCartridgeSlot
var DVDCardtridgeLists
onready var isRunningDVD = true
onready var preloadDVD = 0
onready var doPreloadDVD = false
export(PackedScene) var LoadDVD 
#enum ListOfDVDsTemporarily {Template, AdmobTestoid}

# demo of 3D in 2D official Godot
func _zetrixInit():
	#zetrixViewport.hdr = false
	changeDVDMenu.ReceiveZetrixViewport(zetrixViewport)
	zetrixPreview.ReceiveZetrixViewport(zetrixViewport)
	zetrixViewport.ReceiveRootViewport(get_viewport())
	zetrixViewport.ReinstallOwnWorld()
	# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
	pass

func _sysInit():
	_zetrixInit()
	OS.request_permissions()
	# Yield Modloader PCK to load mods
	ModPckLoader.loadAllMods()
	#yield(ModPckLoader,"modLoaded")
	changeDVDMenu.RefreshDVDs()
	checkForResetMe()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_sysInit()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_just_pressed("debug_showZetrixView"):
		# Press Ctrl + Alt + Shift + T, for Tari
		# https://www.youtube.com/watch?v=HmKcvlLxGqo
		zetrixPreview.show()
		pass
	pass

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
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$DVDCartridgeSlot.get_child(0).queue_free() #queue_free() leaves traces and may cause memory leak!
	# Ah peck! free() error, attempted to free locked object
	#$MetaMenu/ChangeDVDMenu.show()
	$MetaMenu/ChangeDVDMenu.ShowMeSelf()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$DVDCartridgeSlot.get_child(0).free()
	pass

func PatchedChangeDVDNow():
	print("Patched Change DVD!")
	Singletoner.ResumeGameNow()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
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

func _on_ChangeDVDMenu_ItemClickEnterName(loadName):
	print("Receive DVD Click Name " + loadName)
	LoadDVD = load(loadName)
	$DVDCartridgeSlot.PlayDVD(LoadDVD)
	pass

func _on_ChangeDVDMenu_ItemClickEnter(Index):
	# pls don't do this. bad code! use level card system!
	### ANGLE GRINDER
	### REMOVE THESE!
	#print("Receive DVD Click Index No. " + String(Index))
#	match Index:
#		0:
#			LoadDVD = load("res://GameDVDCardtridge/TemplateHexagonEngine/bootThisLegacyHexagonEngine.tscn")
#			pass
#		1:
#			LoadDVD = load("res://GameDVDCardtridge/AdmobberTestio/AdmobberTestio.tscn")
#			pass
#		2:
#			LoadDVD = load("res://GameDVDCardtridge/ParlorClassic/Parlor.tscn")
#			pass
#		3:
#			LoadDVD = load("res://GameDVDCardtridge/IsengHedBoll/IsengModeHeddBoll.tscn")
#			pass
#		4:
#			LoadDVD = load("res://GameDVDCardtridge/YoneMIDIArea_Prosotipe/YoneMIDIarea.tscn")
#			pass
#		5: 
#			LoadDVD = load("res://GameDVDCardtridge/404/404.tscn")
#			pass
#		6:
#			LoadDVD = load("res://GameDVDCardtridge/BolaAccelerometer/BolaAccelerometer.tscn")
#			pass
#		7:
#			LoadDVD = load("res://GameDVDCardtridge/Splitscrin/Splitscrin Taris.tscn")
#			pass
#		8:
#			LoadDVD = load("res://GameDVDCardtridge/ChangeDVDv3/bootThis.tscn")
#			pass
#		9:
#			LoadDVD = load("res://GameDVDCardtridge/ManOfCoyote/ManOfCoyote.tscn")
#			pass
#		10:
#			LoadDVD = load("res://GameDVDCardtridge/DetakJantungProsotipe/DetakJantungProsotipe.tscn")
#			pass
#		11:
#			LoadDVD = load("res://GameDVDCardtridge/AnTransitionations/AnTransitionation.tscn")
#			pass
#		12:
#			LoadDVD = load("res://GameDVDCardtridge/TostLeveling/TostLeveling.tscn")
#			pass
#		13:
#			LoadDVD = load("res://GameDVDCardtridge/ExportMyself/ExportMyself.tscn")
#			pass
#		14:
#			LoadDVD = load("res://GameDVDCardtridge/WhereIsLoadingBarFunctions/WhereIsLoadingFunctions.tscn")
#		_:
#			LoadDVD = load("res://GameDVDCardtridge/404/404.tscn")
#			pass
#	$DVDCartridgeSlot.PlayDVD(LoadDVD)
	# deprecated
	### PAIN IS TEMPORARY
	### GLORY IS FOREVER
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

enum DialogReason {Nothing, ResetMe}
var SelectDialogReason
var ResetSay = "Reset Factory DIP switch is on! Reset setting?"
func checkForResetMe():
	if Settingers.checkForResetMe():
		SelectDialogReason = DialogReason.ResetMe
		var theDialog = $MetaMenu/AreYouSureDialog
		theDialog.SpawnDialogWithText(ResetSay)
		var whatAnswer = yield(theDialog, "YesOrNoo")
		if whatAnswer:
			Settingers.engageFactoryReset()
		else:
			#Settingers.SettingData["PleaseResetMe"] = false
			Settingers.cancelReset()
		pass
		
	else:
		
		pass
	$DVDCartridgeSlot.CheckDVD()
	pass

func _on_AreYouSureDialog_YesOrNoo(which):
	# YesNoYes
	pass # Replace with function body.


func _on_ChangeDVDMenu_CustomLoadMoreDVD(path):
	print("Custom load this ", path, " right here")
	LoadDVD = load(path)
	$DVDCartridgeSlot.PlayDVD(LoadDVD)
	pass # Replace with function body.
