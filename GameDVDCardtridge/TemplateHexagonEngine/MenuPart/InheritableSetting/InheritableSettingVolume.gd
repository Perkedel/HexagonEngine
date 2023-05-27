@tool
extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export (float, -80, 24) var VolumeLevel = 0
@export (String) var UnitName = "dB"
@export (float) var VolumeMin = -80
@export (float) var VolumeMax = 24
@export (String) var VariableName = "Volume"
@export (bool) var InitiativelyControlVolumeBus = false
@export (bool) var EmitVolumeSignal = true
@export (bool) var EmitSliderReleased = true
@export (bool) var PlayTestoidFile = false
@export (String) var VolumeBus = "Dummy"
@export (AudioStream) var TestoidAudio
@export (float, 0.01, 32) var TestoidPitch = 1

var VolumeHasLoaded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/HSlider.min_value = VolumeMin
	$HBoxContainer/HSlider.max_value = VolumeMax
	$Testoider.stream = TestoidAudio
	$Testoider.bus = VolumeBus
	$Testoider.pitch_scale = TestoidPitch
	
	VolumeLevel = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VolumeBus))
	SetVolume(VolumeLevel)
	VolumeHasLoaded = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	
	$LabelContainer/Label.text = VariableName
	$LabelContainer/LabelValue.text = String($HBoxContainer/HSlider.value) + " " + String(UnitName)
	pass

func SetVolume(value : float) -> void:
	$HBoxContainer/HSlider.value = value
	print("Slider: " + String(value))
	pass

# https://godotengine.org/qa/60870/how-do-i-change-datatype-of-a-signal-using-gdscript
# help wanted
# signal ValueOfIt(value: float)
signal ValueOfIt(value)
func _on_HSlider_value_changed(value, valou):
	if VolumeHasLoaded:
		VolumeLevel = value
		if EmitVolumeSignal:
			emit_signal("ValueOfIt", value)
			pass
		
		if InitiativelyControlVolumeBus:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index(VolumeBus), value)
			#Settingers.SettingData.AudioSetting[VolumeBus + "Volume"] = value
			Settingers.setVolume(VolumeBus + "Volume", value)
			#Settingers.SettingSave()
			pass
		print("Slider: " + String(value) + ", Valou: " + String(valou))
	pass # Replace with function body.

signal HasChanged
func _on_HSlider_changed():
	if VolumeHasLoaded:
		emit_signal("HasChanged")
	pass # Replace with function body.

signal SliderReleased
func _on_HSlider_gui_input(event : InputEvent):
	if event.is_action_released("ui_mouse_left"):
		if EmitSliderReleased:
			emit_signal("SliderReleased")
			pass
		
		if PlayTestoidFile and VolumeHasLoaded:
			$Testoider.play()
			pass
		pass
	pass # Replace with function body.

func _on_InheritableSettingVolume_visibility_changed():
	VolumeHasLoaded = false
	VolumeLevel = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(VolumeBus))
	SetVolume(VolumeLevel)
	VolumeHasLoaded = true
	pass # Replace with function body.
