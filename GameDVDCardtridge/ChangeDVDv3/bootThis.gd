extends Node

# Are you coding son
# Unity is not Open Source and Limited!
# Daddy is disappointed!

# Made with Godot in style of "Made with Unity"
export(float) var TimeDelay
export(PackedScene) var bootTheDVD = load("res://GameDVDCardtridge/ChangeDVDv3/ChangeDVDv3.tscn")
export(String) var bootTheDVDpath = "res://GameDVDCardtridge/ChangeDVDv3/ChangeDVDv3.tscn"
# onready var loadingResource = ResourceLoader()
export(PoolStringArray) var bootBannerLocations = [
	"res://GameDVDCardtridge/ChangeDVDv3/Shared/bootBanner/RowCellPerkedel.tscn",
	"res://GameDVDCardtridge/ChangeDVDv3/Shared/bootBanner/RowCellA.tscn",
]
export(float) var fadeSplashIn = .5
onready var resourcering = preload("res://Scripts/ExtraImportAsset/resource_queue.gd").new()
var ContainsBootBannerInstance
var ContainsDVDInstance
var pleaseJustSkip = false

onready var tween = $Tweenee
onready var indexBootBanner = 0
onready var howManyBootBanners = 0
onready var finishedBootBanner = false
onready var finishedDVDLoading = false
onready var hasTooDone = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func loadBootBanner(var which:String):
	howManyBootBanners = $Splash/SplashMan/SplashControl/ColumnStack.get_child_count()
	ContainsBootBannerInstance = load(which).instance()
	$Splash/SplashMan/SplashControl/ColumnStack.add_child(ContainsBootBannerInstance)
	for childrens in $Splash/SplashMan/SplashControl/ColumnStack.get_children():
		childrens.connect("ImDone", self, "_on_RowCell_ImDone")
		childrens.connect("ImDone", $Splash/SplashMan/SplashControl/ColumnStack, "_on_ImDone")
	pass

func removeBootBanners():
	#
	for things in $Splash/SplashMan/SplashControl/ColumnStack.get_children():
		#
		$Splash/SplashMan/SplashControl/ColumnStack.remove_child(things)
		things.queue_free()
		pass
	pass

func removeThisBootBanner():
	howManyBootBanners = $Splash/SplashMan/SplashControl/ColumnStack.get_child_count()
	$Splash/SplashMan/SplashControl/ColumnStack.get_child(0).queue_free()
	pass

func DestroySplashScreen():
	$Splash/SplashMan/SplashControl/ColumnStack.queue_free()
	pass

func loadTray(whatDVD):
	print("\n\n\nWOW DVD Finish now load\n\n\n")
	ContainsDVDInstance = whatDVD.instance()
	$Tray.add_child(ContainsDVDInstance)
	$Tray.get_child(0).connect("ChangeDVD_Exec", self, "_on_ChangeDVD_Exec")
	$Tray.get_child(0).connect("Shutdown_Exec", self, "_on_Shutdown_Exec")
	pass

func _splashing():
	#$"Splash/CanvasLayer/SplashControl".modulate = Color(1,1,1,0)
	#$Splash/CanvasLayer/SplashControl/ColumnStack/RowCell.rect_scale = Vector2(.5,.5)
#	tween.interpolate_property($"Splash/CanvasLayer/SplashControl/ColumnStack/RowCellA", "modulate", Color(1,1,1,0), Color(1,1,1,1), .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	tween.interpolate_property($"Splash/CanvasLayer/SplashControl/ColumnStack/RowCellA", "rect_scale", Vector2(.5,.5), Vector2(1.5,1.5), 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	tween.start()
	# bootTheDVDpath = bootTheDVD
	resourcering.start()
	resourcering.queue_resource(bootTheDVDpath)
	for bootBannersHere in bootBannerLocations:
		howManyBootBanners = $Splash/SplashMan/SplashControl/ColumnStack.get_child_count()
		print("Load " + bootBannersHere)
		loadBootBanner(bootBannersHere)
		yield($Splash/SplashMan/SplashControl/ColumnStack, "ImDone")
		print("Done the " + bootBannersHere)
		# $Splash/SplashMan/SplashControl/ColumnStack.get_child(0).queue_free()
		if pleaseJustSkip:
			ContainsBootBannerInstance.justSkipAlready()
			break
		pass
	finishedBootBanner = true
	# yield(resourcering,"iAmReady")
	while not finishedDVDLoading:
		# print("whiler")
		if resourcering.is_ready(bootTheDVDpath):
			finishedDVDLoading = true
			print("\n\nFinished DVD Loading\n\n")
			pass
		pass
	tween.interpolate_property($Splash/SplashMan/SplashControl, "modulate", Color(1,1,1,1), Color(1,1,1,0), fadeSplashIn, Tween.TRANS_LINEAR,Tween.EASE_OUT, 0)
	tween.interpolate_property($Splash/BekgronMan/BekgronControl, "modulate", Color(1,1,1,1), Color(1,1,1,0), fadeSplashIn, Tween.TRANS_LINEAR,Tween.EASE_OUT, 0)
	tween.start()
	loadTray(resourcering.get_resource(bootTheDVDpath))
	yield(tween, "tween_all_completed")
	$Splash/SplashMan/SplashControl.hide()
	$Splash/BekgronMan/BekgronControl.hide()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_splashing()
	pass # Replace with function body.

func skipSplash():
	pleaseJustSkip = true
	if not finishedBootBanner:
		ContainsBootBannerInstance.justSkipAlready()
	if finishedDVDLoading and not finishedBootBanner:
		#ContainsBootBannerInstance.justSkipAlready()
		#$Splash/SplashMan/SplashControl/ColumnStack.get_child(0).justSkipAlready()
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Splash/CanvasLayer/SplashControl.modulate += Color(0,0,0,1 * delta)
	
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			skipSplash()
			pass


func _on_Tween_tween_all_completed():
	
	pass # Replace with function body.


func _on_DelayTimer_timeout():
	
	pass # Replace with function body.


func _on_RowCell_ImDone():
	removeBootBanners()
	#removeThisBootBanner()
	pass # Replace with function body.

func _on_ChangeDVD_Exec():
	emit_signal("ChangeDVD_Exec")
	pass

func _on_Shutdown_Exec():
	emit_signal("Shutdown_Exec")
	pass
