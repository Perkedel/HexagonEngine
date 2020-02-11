extends Node2D

export (float) var Y_initPos
export (float) var Y_AddPos
export (int) var VU_counts = 16
export (float) var FrequencyMax = 11050.0
export (float) var min_dB = 60
export (float) var MultiplyPower = 500
export (String) var AnalyzeBus = "Master"
export (int) var WhereIsSpectrumAnalyzerEffect = 0
var spectrum
export (String) var FilePath = ""
export (String) var FileReversal = "../../../../../../../../../../"
var openFile
export (AudioStream) var FileAudio
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func TestoidDummyFileMake():
	var TestoidFile = File.new()
	TestoidFile.open("user://TestoidDummy.txt", File.WRITE)
	TestoidFile.store_string("Testoid\nDummy")
	print("Testoid Location= "+ TestoidFile.get_path_absolute())
	TestoidFile.close()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	TestoidDummyFileMake()
	#LoadFile(FileAudio)
	SetAudioStream(FileAudio)
	spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index(AnalyzeBus), WhereIsSpectrumAnalyzerEffect)
	
	pass # Replace with function body.

func Spectruder():
	VU_counts = $SpectrumPillars.get_child_count()
	var prev_Hz = 0
	for i in range(1, VU_counts+1):
		var hz = i * FrequencyMax / VU_counts
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_Hz, hz).length()
		var energy = clamp((min_dB + linear2db(magnitude)) / min_dB, 0,1)
		
		$SpectrumPillars.get_node("VU Pillar"+String(i)).SetAddHeight(energy * MultiplyPower)
		
		#print("Itterate " + String(i) + ", Freq "+ String(hz) + "Hz = " + String(energy))
		prev_Hz = hz
		pass
	pass

func PlaySong():
	$MusicController/MusicUI/MusicPlaySpeaker.play()
	pass

func StopSong():
	$MusicController/MusicUI/MusicPlaySpeaker.stop()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Spectruder()
	$MusicController/MusicUI/MainContains/Label/Title.text = FilePath
	pass

func SetPath(path):
	FilePath=path
	pass
#Documentation Help
func GetFile(path):
	SetPath(path)
	openFile = File.new()
	if openFile.open(path, File.READ) == OK:
		print("Open file= " + path)
		var content = openFile
		openFile.close()
		return content
		pass
	else:
		return null
		pass

	pass

func LoadFile(filer : String):
	#FilePath = String(filer)
	SetAudioStream(load(filer))
	pass

func SetAudioStream(filer:AudioStream):
	FileAudio = filer
	$MusicController/MusicUI/MusicPlaySpeaker.stream = FileAudio
	pass

func _on_FileDialog_file_selected(path):
	#LoadFile(path)
	#LoadFile(GetFile(path))
	#SetAudioStream(load(GetFile(path)))
	SetPath(path)
	# Help Wanted
	# Play music from harddisk external not working due to weird permissioner
	# loads it but won't
	$MusicController/MusicUI/MusicPlaySpeaker.stream = load("user://"+ FileReversal +FilePath)
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	$MusicController/MusicUI/MainContains/ControllingMusic/Play.pressed = false
	pass # Replace with function body.


func _on_Play_pressed():
	pass # Replace with function body.


func _on_LoadSong_pressed():
	$MusicController/MusicUI/FileDialog.popup()
	pass # Replace with function body.


func _on_Play_toggled(button_pressed):
	if button_pressed:
		PlaySong()
		pass
	else:
		StopSong()
		pass
	pass # Replace with function body.
