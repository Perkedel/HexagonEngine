extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Loader.connect("_play", self, 'play')

func play(stream):
	$player.set_stream(stream)
	$player.play()

func _on_Button_pressed():
	Loader.file_popup()
