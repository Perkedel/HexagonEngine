extends Node

var wordene : String
var subWordene : String
var progro = 0 # stage loaded (value)
var progron = 0 # Of this many (max)
var pathon : String
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SceneLoader.connect("on_progress",self,"_watch_progress")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wordene = "Exclusive Boot Test"
	subWordene = "is loading: " + pathon + " Stage: " + String(progro) + "/" + String(progron)
	$UI/VBoxContainer/Label.text = wordene
	$UI/VBoxContainer/SubLabel.text = subWordene
	pass

func _watch_progress(path,stage_count = 0.0,stages = 0.0):
	progro = stages
	progron = stage_count
	pathon = String(path)
	$UI/VBoxContainer/ProgressBar.value = (float(stages)/float(stage_count))*100.00
	pass

func _on_ReturnButton_pressed():
	Singletoner.ReturnToBios()
	pass # Replace with function body.
