extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

# Fromlink
# https://www.youtube.com/watch?v=o77wFWau9Wc
# https://www.youtube.com/watch?v=AkfTW2Tq3MM
# https://www.youtube.com/watch?v=q4MdQ5c-NIY

func _on_MasterVolume_ValueOfIt(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	print("Set Master Volume: " + String(value))
	# https://freesound.org/people/qubodup/sounds/60007/
	# https://freesound.org/people/moogy73/sounds/425728/
	#$Testoid.play()
	pass # Replace with function body.


func _on_Music_ValueOfIt(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	print("Set Music Volume: " + String(value))
	#$TestoidMusic.play()
	pass # Replace with function body.


func _on_SoundEffect_ValueOfIt(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffect"), value)
	print("Set Sound Volume: " + String(value))
	#$TestoidSFX.play()
	pass # Replace with function body.


func _on_MasterVolume_HasChanged():
	#$Testoid.play()
	pass # Replace with function body.

func _on_Music_HasChanged():
	pass # Replace with function body.

func _on_SoundEffect_HasChanged():
	pass # Replace with function body.


func _on_MasterVolume_SliderReleased():
	$Testoid.play()
	pass # Replace with function body.


func _on_Music_SliderReleased():
	$TestoidMusic.play()
	pass # Replace with function body.


func _on_SoundEffect_SliderReleased():
	$TestoidSFX.play()
	pass # Replace with function body.



