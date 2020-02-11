extends VBoxContainer

var Spectrum
export (String) var AnalyzeBus = "Master"
export (int) var EffectAnalyze = 0
export (float) var minDB = 60
export (float) var MaxFrequency = 44100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index(AnalyzeBus), EffectAnalyze)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Spectrumer()
	pass

func Spectrumer():
	var Magnitude:float = Spectrum.get_magnitude_for_frequency_range(0,MaxFrequency).length()
	var energy = clamp((minDB + linear2db(Magnitude)) / minDB, 0, 1)
	$AudioTestMeter.SetValue(energy)
	pass

func StopTesting():
	$AudioTestPlayer.DeToggle()
	pass

# Fromlink
# https://www.youtube.com/watch?v=o77wFWau9Wc
# https://www.youtube.com/watch?v=AkfTW2Tq3MM
# https://www.youtube.com/watch?v=q4MdQ5c-NIY

func _on_MasterVolume_ValueOfIt(value):
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	#print("Set Master Volume: " + String(value))
	# https://freesound.org/people/qubodup/sounds/60007/
	# https://freesound.org/people/moogy73/sounds/425728/
	#$Testoid.play()
	pass # Replace with function body.


func _on_Music_ValueOfIt(value):
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	#print("Set Music Volume: " + String(value))
	#$TestoidMusic.play()
	pass # Replace with function body.


func _on_SoundEffect_ValueOfIt(value):
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffect"), value)
	#print("Set Sound Volume: " + String(value))
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
	#$Testoid.play()
	pass # Replace with function body.


func _on_Music_SliderReleased():
	#$TestoidMusic.play()
	pass # Replace with function body.


func _on_SoundEffect_SliderReleased():
	#$TestoidSFX.play()
	pass # Replace with function body.



