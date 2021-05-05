extends Control

var beate:String
var measuree:String
var insertTheCardtridge = load("res://Audio/MusicCardtridge/Musik/Floaters.tres")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	AutoSpeaker.connect("beat",self,"_on_AutoSpeaker_beat")
	AutoSpeaker.connect("measure",self,"_on_AutoSpeaker_measure")
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	AutoSpeaker.inserMediaCardtridge(insertTheCardtridge)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SuperLabel.text = "Beat Measure = " + beate + " " + measuree
	pass

func _on_AutoSpeaker_beat(position):
	$Beat.play()
	beate = String(position)
	pass

func _on_AutoSpeaker_measure(position):
	$Measure.play()
	measuree = String(position)
	pass

func _on_PlaySong_pressed():
	AutoSpeaker.playTheMusic(8)
	pass # Replace with function body.


func _on_StopSong_pressed():
	AutoSpeaker.stopTheMusic()
	pass # Replace with function body.
