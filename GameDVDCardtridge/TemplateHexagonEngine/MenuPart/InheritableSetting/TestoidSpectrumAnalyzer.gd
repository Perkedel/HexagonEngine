extends HBoxContainer

export (String) var VariableName = "Spectrum Analyzer"
export (String) var AnalyzeBus = "Master"
export (int) var WhereIsSpectrumAnalyzerEffect = 0
export (bool) var InitiativelyAnalyze = true
export (float) var FrequencyMax=11050.0
export (float) var min_dB = 60
export (int) var VU_counts
var spectrum
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# https://github.com/godotengine/godot-demo-projects/blob/master/audio/spectrum/show_spectrum.gd
# Called when the node enters the scene tree for the first time.
func _ready():
	spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index(AnalyzeBus), WhereIsSpectrumAnalyzerEffect)
	pass # Replace with function body.

func InitiativeSpectrum():
	VU_counts = $HBoxContainer.get_child_count()
	if InitiativelyAnalyze:
		var prev_Hz = 0
		for i in range(1, VU_counts+1):
			var hz = i * FrequencyMax / VU_counts
			var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_Hz, hz).length()
			var energy = clamp((min_dB + linear2db(magnitude)) / min_dB, 0,1)
			
			#$HBoxContainer.get_child(i).value = energy
			get_node("HBoxContainer/VU" + String(i)).value = energy
			#print("Itterate " + String(i) + ", Freq "+ String(hz) + "Hz = " + String(energy))
			prev_Hz = hz
			pass
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = VariableName
	InitiativeSpectrum()
	pass

