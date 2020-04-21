extends Node

export(float) var TimeDelay
export(PackedScene) var bootTheDVD
export(PoolStringArray) var bootBannerLocations
var ContainsBootBannerInstance

onready var tween = $Tween
onready var indexBootBanner = 0
onready var finishedBootBanner = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func loadBootBanner(var which:String):
	ContainsBootBannerInstance = load(which)
	$Splash/SplashMan/SplashControl/ColumnStack.add_child(ContainsBootBannerInstance)
	$Splash/SplashMan/SplashControl/ColumnStack.get_child(0).connect("ImDone", self, "_on_RowCell_ImDone")
	pass

func removeBootBanners():
	for things in $Splash/SplashMan/SplashControl/ColumnStack.get_children():
		things.free()
		pass
	pass

func DestroySplashScreen():
	$Splash/CanvasLayer.queue_free()
	pass

func loadTray():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#$"Splash/CanvasLayer/SplashControl".modulate = Color(1,1,1,0)
	#$Splash/CanvasLayer/SplashControl/ColumnStack/RowCell.rect_scale = Vector2(.5,.5)
#	tween.interpolate_property($"Splash/CanvasLayer/SplashControl/ColumnStack/RowCellA", "modulate", Color(1,1,1,0), Color(1,1,1,1), .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	tween.interpolate_property($"Splash/CanvasLayer/SplashControl/ColumnStack/RowCellA", "rect_scale", Vector2(.5,.5), Vector2(1.5,1.5), 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	tween.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Splash/CanvasLayer/SplashControl.modulate += Color(0,0,0,1 * delta)
	pass


func _on_Tween_tween_all_completed():
	
	pass # Replace with function body.


func _on_DelayTimer_timeout():
	
	pass # Replace with function body.


func _on_RowCell_ImDone():
	removeBootBanners()
	pass # Replace with function body.
