extends Node2D

@export (int) var CrackleCounter
@export (bool) var AllCracklesAreGone = false
@export (float) var Y_initPos
@export (float) var Y_AddPos
@export (int) var VU_counts = 16
@export (int) var VU_coints = 16
@export (float) var FrequencyMax = 11050.0
@export (float) var min_dB = 60
@export (float) var MultiplyPower = 500
@export (String) var AnalyzeBus = "Master"
@export (int) var WhereIsSpectrumAnalyzerEffect = 0
var spectrum
@export (String) var FilePath = ""
@export (String) var FileReversal = "../../../../../../../../../../"
var openFile
@export (AudioStream) var FileAudio
enum FileAccessModes {Resourcer = 0, Userer = 1, FileSystemer = 2, Canceler = -1}
@export (int) var SelectedFileAccess
@onready var GMEPlayer = AutoSpeaker.FLMmusic
var useGME = false
var GMEplayed = false
@onready var ArlezMidi = $MusicController/MusicUI/GodotMIDIPlayer
var useArlezMidi = false
#var Dau = DauMainLooper

# https://github.com/MightyPrinny/godot-FLMusicLib/blob/demo/MyScene.gd
# GME specific variables
var loopStart = 0;
var loopEnd = 0;
var loop = false;
var trackNum = 0;
var vol = "1";

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal reportHP(level)
signal reportScore(number)
signal reportScoreIcon(Texturer)
signal reportNextLevel(cardWhich)
#todo: reportTexture for score icon

func TestoidDummyFileMake():
	var TestoidFile = File.new()
	TestoidFile.open("user://TestoidDummy.txt", File.WRITE)
	TestoidFile.store_string("Testoid\nDummy")
	print("Testoid Location= "+ TestoidFile.get_path_absolute())
	TestoidFile.close()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("files_dropped", Callable(self, "_drag_drop"))
	SetPath(FileAudio.get_path())
	TestoidDummyFileMake()
	#LoadFile(FileAudio)
	SetAudioStream(FileAudio)
	spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index(AnalyzeBus), WhereIsSpectrumAnalyzerEffect)
	GMEPlayer.connect("track_ended", Callable(self, "_GMEtrack_ended"))
	ArlezMidi.connect("appeared_lyric", Callable(self, "_ArlezMIDI_lyric"))
	pass # Replace with function body.

func Spectruder():
	VU_counts = $SpectrumPillars.get_child_count()
	var prev_Hz = 0
	for i in range(1, VU_counts+1):
		var hz = i * FrequencyMax / VU_counts
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_Hz, hz).length()
		var energy = clamp((min_dB + linear_to_db(magnitude)) / min_dB, 0,1)
		
		$SpectrumPillars.get_node("VU Pillar"+String(i)).SetAddHeight(energy * MultiplyPower)
		
		#print("Itterate " + String(i) + ", Freq "+ String(hz) + "Hz = " + String(energy))
		prev_Hz = hz
		pass
	pass

func Spectrader(): # UpsideDown Spectruder Spectrum Pillar
	VU_coints = $SpectrumPillars2.get_child_count()
	var prev_Hz = 0
	for i in range(1, VU_coints+1):
		var hz = i * FrequencyMax / VU_coints
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_Hz, hz).length()
		var energy = clamp((min_dB + linear_to_db(magnitude)) / min_dB, 0,1)
		
		$SpectrumPillars2.get_node("VU Pillar"+String(i)).SetAddHeight(energy * MultiplyPower)
		
		#print("Itterate " + String(i) + ", Freq "+ String(hz) + "Hz = " + String(energy))
		prev_Hz = hz
		pass
	pass

func VUmanner():
	var Magnitude:float = spectrum.get_magnitude_for_frequency_range(0,FrequencyMax).length()
	var energy = clamp((min_dB + linear_to_db(Magnitude)) / min_dB, 0, 1)
	#emit_signal("reportHP",clamp(energy*100,0,100))
	EmitNowHP(clamp(energy*100,0,100))
	pass

func CountCrackleCounts():
	#emit_signal("reportScore", $Crackles.get_child_count())
	CrackleCounter = $Crackles.get_child_count()
	EmitNowScore(CrackleCounter)
	
	if !AllCracklesAreGone and CrackleCounter <= 0:
		print("\n\n(OH NO) YOU HAVE LOST ALL THE CRACKLES!!! OH NO!!! NOOOOOOOOOOOOOOOOOOOOOOOOOOOO!!!!!!!!!(OH NO)\n\n")
		AllCracklesAreGone = true
		pass
	else:
		pass
	pass

func DeTogglePlay():
	$MusicController/MusicUI/MainContains/ControllingMusic/Play.button_pressed = false
	#$MusicUI/MainContains/ControllingMusic/Play.pressed = false
	#GMEPlayer.stop_music()
	pass

func ReTogglePlay():
	$MusicController/MusicUI/MainContains/ControllingMusic/Play.button_pressed = true
	#$MusicUI/MainContains/ControllingMusic/Play.pressed = true
	pass

func PlaySong():
	if useGME:
		GMEPlayer.play_music(FilePath,trackNum,loop,loopStart,loopEnd,0)
		GMEPlayer.set_volume(vol.to_float())
		GMEplayed = true
	elif useArlezMidi:
		ArlezMidi.play()
	else:
		$MusicController/MusicUI/MusicPlaySpeaker.play()
		#$MusicUI/MusicPlaySpeaker.play()
	pass

func StopSong():
	if useGME:
		if GMEplayed:
			GMEPlayer.stop_music()
		GMEplayed = false
	elif useArlezMidi:
		ArlezMidi.stop()
		return
	else:
		$MusicController/MusicUI/MusicPlaySpeaker.stop()
		#$MusicUI/MusicPlaySpeaker.stop()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Spectruder()
	Spectrader()
	VUmanner()
	CountCrackleCounts()
	$MusicController/MusicUI/MainContains/ScrollContainer/Label/Title.text = FilePath
	#$MusicUI/MainContains/Label/Title.text = FilePath
	if Singletoner.isGamePaused:
		if $MusicController/MusicUI.visible:
			$MusicController/MusicUI.hide()
			pass
		pass
	else:
		if !$MusicController/MusicUI.visible:
			$MusicController/MusicUI.show()
			pass
		pass
	pass

func SetPath(path):
	FilePath=path
	#print("Set Path = " + FilePath)
	pass
#Documentation Help
#func GetFile(path):
#	SetPath(path)
#	openFile = File.new()
#	if openFile.open(path, File.READ) == OK:
#		print("Open file= " + path)
#		var content = openFile
#		openFile.close()
#		return content
#		pass
#	else:
#		return null
#		pass
#	pass

#func ProcessAudio(data:PoolByteArray, ScanEndsWith:String = ".wav") -> PoolByteArray:
#	if ScanEndsWith.ends_with(".wav"):
#		pass
#	elif ScanEndsWith.ends_with(".ogg"):
#		pass
#	else:
#		pass
#	return data
#	pass

func ComplicatedLoadFile(path: String, convertData:bool = true, cutNoise:bool = true, ConvertFormat = AudioStreamWAV.FORMAT_16_BITS, ConvertFreqRate:float = 44100, ConvertStereo:bool = true):
	DeTogglePlay()
	
	# Cut Noise Version
	# https://godotengine.org/qa/48384/help-with-import-audio-using-gdscript
	# uriel
	
	# No Cut Noise Version
	# https://godotengine.org/qa/26161/how-to-play-wav-file-recorded-at-runtime
	# Bartosz
	openFile = File.new()
	openFile.open(path,File.READ)
	SetPath(path)
	print("openFile = " + openFile.get_path_absolute())
	var Buffering = openFile.get_buffer(openFile.get_length())
	var streamSample
	#streamSample.data = ProcessAudio(Buffering,path)
	useGME = false
	useArlezMidi = false
	
	if path.ends_with(".wav") or path.ends_with(".WAV"): #Oh no, elseifs!!!
		streamSample = AudioStreamWAV.new()
		if cutNoise:
			print("Cutting Noise...")
			for i in 200:
				Buffering.remove(Buffering.size()-1) # Remove Pop sound at the end
				Buffering.remove(0)
				pass
			# The itterater above causes hiccup! but without it,
			# The experience will POP at the start and the end.
			pass
		if convertData:
			print("Convert Data... = " + String(ConvertFormat) + ", " + String(ConvertFreqRate) + ", Stereo is " + String(ConvertStereo))
			streamSample.format = ConvertFormat # 0 = 8bit; 1 = 16bit; 2 = IMA ADPCM; enum
			streamSample.mix_rate = ConvertFreqRate
			streamSample.stereo = ConvertStereo
			pass
		pass
	elif path.ends_with(".ogg") or path.ends_with(".OGG"):
		# # https://github.com/godotengine/godot/issues/17748#issuecomment-376320424
		streamSample = AudioStreamOggVorbis.new()
		pass
	elif path.capitalize().ends_with(".MP3"):
		streamSample = AudioStreamMP3.new()
		# NEW!!! Godot 3.3 Audio Stream now supports MP3 yay!
		# it's similar way like OGG, just it's MP3
		# https://godotengine.org/article/godot-3-3-has-arrived
		pass
	elif path.ends_with(".xm") or path.ends_with(".mod") or path.ends_with(".it") or path.ends_with(".s3m")or path.ends_with(".XM") or path.ends_with(".MOD") or path.ends_with(".IT") or path.ends_with(".S3M"):
		useGME = true
		pass
	elif path.ends_with(".mid") or path.ends_with(".midi") or path.ends_with(".MID") or path.ends_with(".MIDI"):
		useArlezMidi = true
		pass
	else:
		printerr("/!\\ UNSUPPORTED AUDIO FILE EXTENSION /!\\ Will use GME player")
		print_stack()
#		streamSample = AudioStreamSample.new()
		useGME = true
		pass
	
	pass
	
	if useArlezMidi:
		ArlezMidi.file = openFile.get_path()
		print("Use Arlez80 MIDI player = " + openFile.get_path())
		pass
	elif useGME:
		print("Use GME = " + openFile.get_path())
	else:
		streamSample.data = Buffering
		print("Audio Loaded = " + openFile.get_path())
		FileAudio = streamSample
		$MusicController/MusicUI/MusicPlaySpeaker.stream = streamSample
		pass
	openFile.close()
	#SetAudioStream(streamSample)
	pass

func LoadFile(filer : String):
	FilePath = String(filer)
	SetAudioStream(load(filer))
	pass

func SetAudioStream(filer:AudioStream):
	FileAudio = filer
	$MusicController/MusicUI/MusicPlaySpeaker.stream = FileAudio
	#$MusicUI/MusicPlaySpeaker.stream = FileAudio
	pass

func _on_FileDialog_file_selected(path):
	#LoadFile(path)
	#LoadFile(GetFile(path))
	#SetAudioStream(load(GetFile(path)))
	#SetPath(path)
	# Help Wanted
	# Play music from harddisk external not working due to weird permissioner
	# loads it but won't
	#$MusicController/MusicUI/MusicPlaySpeaker.stream = load("user://"+ FileReversal +FilePath)
	
	$MusicController/MusicUI/FileDialog.hide()
	#$MusicUI/FileDialog.hide()
	# OMG!!! PLS!! IMPLEMENT SWITCH CASE SYNTAX IN GDSCRIPT!!! 
	# I LOOKS LIKE A SILLY DEV!
	if SelectedFileAccess == FileAccessModes.Resourcer:
		LoadFile(path)
		pass
	elif SelectedFileAccess == FileAccessModes.Userer:
		LoadFile(path)
		pass
	elif SelectedFileAccess == FileAccessModes.FileSystemer:
		ComplicatedLoadFile(path)
		pass
	elif SelectedFileAccess == FileAccessModes.Canceler:
		pass
	else:
		pass
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	DeTogglePlay()
	pass # Replace with function body.

func _GMEtrack_ended():
	GMEplayed = false
	DeTogglePlay()
	print("GME end of track")
	pass

func _ArlezMIDI_lyric(lyric):
	##printraw(lyric)
	print(lyric)
	pass

func _on_Play_pressed():
	pass # Replace with function body.


func _on_LoadSong_pressed():
	#$MusicController/MusicUI/FileDialog.popup()
	
	$MusicController/MusicUI/SelectFileLoadingMode.popup()
	#$MusicUI/SelectFileLoadingMode.popup()
	pass # Replace with function body.


func _on_Play_toggled(button_pressed):
	if button_pressed:
		PlaySong()
		pass
	else:
		StopSong()
		pass
	pass # Replace with function body.


func _on_SelectFileLoadingMode_FileAccessModeSelected(Which):
	SelectedFileAccess = Which
	$MusicController/MusicUI/FileDialog.access = Which
	
	if !Which == FileAccessModes.Canceler:
		$MusicController/MusicUI/FileDialog.show()
		pass
	
	#$MusicUI/FileDialog.access = Which
	#$MusicUI/FileDialog.show()
	pass # Replace with function body.



func EmitNowHP(valueo):
	emit_signal("reportHP",valueo)
	pass

func EmitNowScore(valueo):
	emit_signal("reportScore", valueo)
	pass


func _on_Scroncher_body_entered(body):
	CrackleCounter = $Crackles.get_child_count()
	if CrackleCounter >=14:
		print("\n\n(NOTICE)PLEASE DON'T LOSE THE CRACKLES!!! LEFT "+ String(CrackleCounter) +" PCS!!! (NOTICE)\n\n")
		pass
	if CrackleCounter <=5:
		print("\n\n(ATTENTION!!!) YOU ARE GOING TO LOSE ALL CRACKLES! LEFT "+ String(CrackleCounter) +" PCS!!! (ATTENTION!!!)\n\n")
		pass
	pass # Replace with function body.

# https://docs.godotengine.org/en/stable/classes/class_mainloop.html#method-descriptions
# https://github.com/godotengine/godot/issues/5625
# https://www.reddit.com/r/godot/comments/46em5w/minimal_drag_and_drop_example/
# https://godotforums.org/discussion/20252/drag-and-drop-files-to-game-at-runtime
func _drag_drop(filePaths:PackedStringArray,screenOf:int):
	print("Drag Drop the ", filePaths[0], " to screen ", String(screenOf))
	SelectedFileAccess = FileAccessModes.FileSystemer
	_on_FileDialog_file_selected(filePaths[0])
	pass
