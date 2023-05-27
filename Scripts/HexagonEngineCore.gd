extends Node

"""
PERHATIAN

Seluruh skrip akan dikonversi ke format Godot 4.0
harap istirahatkan tangan koding anda terlebih dahulu.

serta plugin akan dirombak serentak.
"""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Function and variables are now on Template
#enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
#export(MenuLists) var MenuIsRightNow = 0
#export var isPlayingTheGameNow = false
#export var PauseTheGame = false
#var ConThread

#@onready # Godot 4.0
#onready var zetrixViewport = $ZetrixViewport
@onready var changeDVDMenu = $MetaMenu/ChangeDVDMenu
@onready var zetrixPreview = $MetaMenu/JustZetrixVRViewer
@onready var dvdSlot = $DVDCartridgeSlot
@onready var dvdSelBg = $MetaMenu/DVDSelectBackground
@onready var dvdSelTr= $MetaMenu/DVDSelectTransitioner
@onready var dvdLauBg = $MetaMenu/CenterBgLaunch/DVDLaunchBackground
@onready var cenBgLaunch = $MetaMenu/CenterBgLaunch
@onready var tweens = $SystemGut/aTweens.get_children()
@onready var immediateTween = $SystemGut/aTweens/Tween1
@onready var immediateTween2 = $SystemGut/aTweens/Tween2
@onready var timerer = $SystemGut/Timer
@onready var LoadingPopup = $MetaMenu/LoadingPopup
var DVDCardtridgeLists
@onready var isRunningDVD = false
@onready var preloadDVD = 0
@onready var doPreloadDVD = false
@onready var resourceQueued = preload("res://Scripts/ExtraImportAsset/resource_queue.gd").new()
@export var LoadDVD: PackedScene 
#enum ListOfDVDsTemporarily {Template, AdmobTestoid}
var LoadingProgressNum:float=0.0

# demo of 3D in 2D official Godot
func _zetrixInit():
	XRServer.find_interface("OpenXR")
	#zetrixViewport.hdr = false
#	changeDVDMenu.ReceiveZetrixViewport(zetrixViewport)
#	zetrixPreview.ReceiveZetrixViewport(zetrixViewport)
#	zetrixViewport.ReceiveRootViewport(get_viewport())
#	zetrixViewport.ReinstallOwnWorld()
	# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
	pass

func _sysInit():
	print("Welcome to Hexagon Engine")
	Singletoner.iAmTheMainNode(self)
	print("Locate " + String(OS.get_executable_path()))
	resourceQueued.start()
	_zetrixInit()
	OS.request_permissions()
	changeDVDMenu.RefreshDVDs()
	#yield(changeDVDMenu,"DVDListRefreshed")
	# https://godotengine.org/qa/24281/godot-yield-there-wait-function-execution-ended-completely
	# Yield Modloader PCK to load mods
	#ModPckLoader.wellLoadModsFolder()
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
		# Press Ctrl + Shift + T, for Tari
		# https://www.youtube.com/watch?v=HmKcvlLxGqo
		if zetrixPreview.visible:
			zetrixPreview.hide()
		else:
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

func interceptFiftConsole(path:String):
	await get_tree().idle_frame
	cenBgLaunch.show()
	immediateTween.interpolate_property(dvdLauBg,"modulate",Color(1,1,1,0),Color(1,1,1,1),.3)
	immediateTween.interpolate_property(dvdLauBg,"scale",Vector2(.5,.5),Vector2(1,1),.3)
	LoadingPopup.SpawnLoading()
	dvdSelBg.hide()
	dvdSelTr.hide()
	dvdLauBg.show()
	immediateTween.start()
	resourceQueued.queue_resource(path)
	timerer.one_shot = true
	timerer.start(1.0)
	while not resourceQueued.is_ready(path) or not timerer.is_stopped():
		await get_tree().idle_frame
		#print("Loading DVD ",path," Progress: ", resourceQueued.get_progress(path))
		#print("Timer is ", "Stopped" if timerer.is_stopped() else "Starting", String(timerer.time_left))
		LoadingPopup.ManageLoading(resourceQueued.get_progress(path) * 100, path, true if resourceQueued.get_progress(path) == 1.0 else false)
#		if resourceQueued.is_ready(path) && timerer.is_stopped():
#			break
		if Input.is_action_just_pressed("ui_mouse_left"):
			timerer.stop()
			pass
		pass
#	while not timerer.is_stopped():
#		print("Loading DVD ",path," Progress: ", resourceQueued.get_progress(path))
#		print("Timer is ", "Stopped" if timerer.is_stopped() else "Starting", String(timerer.time_left))
#		pass
	if resourceQueued.is_ready(path):
		LoadDVD = resourceQueued.get_resource(path)
		pass
	#yield(get_tree().create_timer(1),"timeout")
	#dvdLauBg.hide()
	#dvdSelBg.hide()
	#cenBgLaunch.hide()
	pass

func postInterception():
	immediateTween.interpolate_property(dvdLauBg,"modulate",Color(1,1,1,1),Color(1,1,1,0),.3)
	cenBgLaunch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dvdSelBg.hide()
	immediateTween.start()
	await immediateTween.tween_all_completed
	LoadingPopup.DespawnLoading()
	cenBgLaunch.hide()
	cenBgLaunch.mouse_filter = Control.MOUSE_FILTER_STOP
	dvdLauBg.hide()
	pass

func DoChangeDVDNow():
	print("Change DVD!")
	cenBgLaunch.hide()
	immediateTween.interpolate_property(dvdSelBg,"modulate",Color(1,1,1,0),Color(1,1,1,1),.75)
	immediateTween.interpolate_property(dvdSelTr,"modulate",Color(1,1,1,0),Color(1,1,1,1),.75)
	dvdSelBg.hide()
	dvdSelTr.show()
	dvdLauBg.hide()
	immediateTween.start()
	Singletoner.ResumeGameNow()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$DVDCartridgeSlot.get_child(0).queue_free() #queue_free() leaves traces and may cause memory leak!
	# Ah peck! free() error, attempted to free locked object
	#$MetaMenu/ChangeDVDMenu.show()
	$MetaMenu/ChangeDVDMenu.ShowMeSelf()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$DVDCartridgeSlot.get_child(0).free()
	isRunningDVD = false
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

func _on_ChangeDVDMenu_ItemClickEnterName(loadName, ExclusiveBootStatement):
	print("Receive DVD Click Name " + loadName," Which " + "Does" if ExclusiveBootStatement else "Doesn't", " Exclusive Boot.")
	await interceptFiftConsole(loadName).completed
	postInterception()
	if ExclusiveBootStatement:
		# Singletoner.hereTakeThisLoadedResource = LoadDVD
		# and scronch me
		Singletoner.ExclusiveBoot(LoadDVD)
		pass
	else:
		#LoadDVD = load(loadName)
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
		var whatAnswer = await theDialog.YesOrNoo
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
	#LoadDVD = load(path)
	await interceptFiftConsole(path).completed
	postInterception()
	$DVDCartridgeSlot.PlayDVD(LoadDVD)
	isRunningDVD = true
	pass # Replace with function body.


func _on_ChangeDVDMenu_updateSelectionAssets(hoverImage, launchImage, hoverAudio, launchAudio):
	var prevSelBg = dvdSelBg.texture
	var prevLauBg = dvdLauBg.texture
#	immediateTween.interpolate_property(dvdSelBg,"texture",prevSelBg,hoverImage,.3)
#	immediateTween.interpolate_property(dvdLauBg,"texture",prevLauBg,launchImage,.3)
#	immediateTween.start()
#	yield(immediateTween,"tween_all_completed")
	dvdSelBg.texture = hoverImage
	dvdSelTr.transitionInto(hoverImage)
	dvdLauBg.texture = launchImage
	pass # Replace with function body.


func _on_ChangeDVDMenu_DVDListRefreshed():
	pass # Replace with function body.


func _on_GCode_done():
	if not isRunningDVD:
		print("CheatoCode done")
		pass
	pass # Replace with function body.
