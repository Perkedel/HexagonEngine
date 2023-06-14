@tool
extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var VolumeLevel:float = 0 # float, -80, 24
@export var UnitName:String = "dB"
@export var VolumeMin:float = -80
@export var VolumeMax:float = 24
@export var VariableName:String = "Volume"
@export var InitiativelyControlVolumeBus:bool = false
@export var EmitVolumeSignal:bool = true
@export var EmitSliderReleased:bool = true
@export var PlayTestoidFile:bool = false
@export var VolumeBus:String = "Dummy"
@export var TestoidAudio:AudioStream
@export var TestoidPitch:float = 1 # float, 0.01, 32

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
	$LabelContainer/LabelValue.text = String.num($HBoxContainer/HSlider.value) + " " + String(UnitName)
	pass

func SetVolume(value : float) -> void:
	$HBoxContainer/HSlider.value = value
	print("Slider: " + String.num(value))
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
