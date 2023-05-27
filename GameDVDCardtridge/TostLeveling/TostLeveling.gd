extends Node

var loadTheLevel
var levelInstance
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChangeDVDButton_pressed():
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


func _on_ExitGameButton_pressed():
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.


func _on_Unload_pressed():
	$LevelSlot.remove_child($LevelSlot.get_child(0))
	pass # Replace with function body.


func _on_Level_1_pressed():
	if $LevelSlot.get_children(): $LevelSlot.remove_child($LevelSlot.get_child(0))
	loadTheLevel = load("res://GameDVDCardtridge/TostLeveling/Level 1.tscn")
	levelInstance = loadTheLevel.instantiate()
	$LevelSlot.add_child(levelInstance)
	$LevelSlot.get_child(0).connect("goNextLevel", Callable(self, "_on_NextLevel"))
	pass # Replace with function body.


func _on_Level_3_pressed():
	pass # Replace with function body.

func _on_NextLevel(whata):
	$LevelSlot.remove_child($LevelSlot.get_child(0))
	loadTheLevel = load(whata)
	levelInstance = loadTheLevel.instantiate()
	$LevelSlot.add_child(levelInstance)
	$LevelSlot.get_child(0).connect("goNextLevel", Callable(self, "_on_NextLevel"))
	pass


func _on_Level_2_pressed():
	if $LevelSlot.get_children(): $LevelSlot.remove_child($LevelSlot.get_child(0))
	loadTheLevel = load("res://GameDVDCardtridge/TostLeveling/Level 2.tscn")
	levelInstance = loadTheLevel.instantiate()
	$LevelSlot.add_child(levelInstance)
	$LevelSlot.get_child(0).connect("goNextLevel", Callable(self, "_on_NextLevel"))
	pass # Replace with function body.
