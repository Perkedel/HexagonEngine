extends Control

var beate:String
var measuree:String
var insertTheCardtridge = load("res://Audio/MusicCardtridge/Musik/Floaters.tres")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	AutoSpeaker.connect("beat", Callable(self, "_on_AutoSpeaker_beat"))
	AutoSpeaker.connect("measure", Callable(self, "_on_AutoSpeaker_measure"))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(get_tree().create_timer(1),"timeout")
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
	AutoSpeaker.playTheMusic(0)
	$MusicNamePop.receiveDictionaryOfMusicName(AutoSpeaker.get_musicName())
	$MusicNamePop.popTheName()
	pass # Replace with function body.


func _on_StopSong_pressed():
	AutoSpeaker.stopTheMusic()
	pass # Replace with function body.
