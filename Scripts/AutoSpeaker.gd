extends AudioStreamPlayer

var externalMusicPopName

var _insertMediaHere:MediaCardtridge
var FLMmusic = FLMusicLib.new()
var MusicNamePopup = MusicNamePop.new()
var AutoSFX = AudioStreamPlayer.new()
var AutoMusic = AudioStreamPlayer.new()
var startTimer = Timer.new()
#var ButtonSound = AudioStreamPlayer.new()
var ButtonSoundFX : String = "res://Audio/EfekSuara/448081__breviceps__tic-toc-click.wav"
#var ArlezMIDI = MidiPlayer.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# https://godotforums.org/discussion/22756/button-sound

# Rhythm sTILEr
## Tracking positon
export(float) var BPM = 120
export(int) var timeMeasures = 4
var initBPM = 120
var initTimeMeasures = 4
var song_position:float = 0.0
var song_position_in_beats:int = 1
var sec_per_beat:float = 60.0 / BPM
var last_reported_beat:int = 0
var beats_before_start:int = 0
var measure:int = 1
## Determining how close to the beat an event is
var closest:int = 0
var time_off_beat:float = 0.0

signal beat(position)
signal measure(position)

## func
func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > timeMeasures:
			measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", measure)
		last_reported_beat = song_position_in_beats
		measure += 1

func play_with_beat_offset(num):
	beats_before_start = num
	startTimer.wait_time = sec_per_beat
	startTimer.start()

func _reset_rhythm():
	BPM = initBPM
	timeMeasures = initTimeMeasures
	song_position = 0.0
	song_position_in_beats = 1
	sec_per_beat = 60.0 / BPM
	last_reported_beat = 0
	beats_before_start = 0
	measure = 1
	closest = 0
	time_off_beat = 0.0
	pass

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat, offset):
	AutoMusic.play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % timeMeasures

func setInitBPMMeasure(Sbpm:float=BPM,Smeasures:int=timeMeasures):
	initBPM = Sbpm
	initTimeMeasures = Smeasures
	pass
func changeBPM(into:float):
	BPM = into
	_calibrateSecPerBeat()
	pass
func _calibrateSecPerBeat():
	sec_per_beat = 60.0 / BPM
	pass

func changeTimeMeasure(into:int):
	timeMeasures = into

## signal endpoint
func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		startTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		startTimer.wait_time = startTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		startTimer.start()
	else:
		AutoMusic.play()
		startTimer.stop()
	_report_beat()
# https://youtu.be/_FRiPPbJsFQ https://github.com/LegionGames/Conductor-Example/ Rhythm sTILEr conductor
# https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html

func inserMediaCardtridge(thisCardtridge:MediaCardtridge):
	if thisCardtridge is MediaCardtridge:
		_insertMediaHere = thisCardtridge
	else:
		printerr("WERROR! Resource inserted must be Media Cardtridge!")
		return
	
	#MusicNamePopup.processTheName(_insertMediaHere.title,_insertMediaHere.artist,_insertMediaHere.license,_insertMediaHere.source[0],_insertMediaHere.albumPic)
	if externalMusicPopName && externalMusicPopName.has_method("processTheName"):
		externalMusicPopName.processTheName(_insertMediaHere.title,_insertMediaHere.artist,_insertMediaHere.license,_insertMediaHere.source[0],_insertMediaHere.albumPic)
		pass
	AutoMusic.stream = _insertMediaHere.Audios[0]
	changeBPM(_insertMediaHere.tempo)
	changeTimeMeasure(_insertMediaHere.timeMeasures)
	setInitBPMMeasure(BPM,timeMeasures)
	pass

func playTheMusic(offset = 0):
	_reset_rhythm()
	if not AutoMusic.playing:
		#play_with_beat_offset(offset)
		play_from_beat(1,offset)
		#MusicNamePopup.popTheName()
	MusicNamePopup.show()
	if externalMusicPopName:
		externalMusicPopName.show()
	pass

func stopTheMusic():
	AutoMusic.stop()
	startTimer.stop()
	_reset_rhythm()
	
	pass

func playSFXNow(stream:AudioStream):
	AutoSFX.stream = stream
	AutoSFX.play()
	pass

func get_musicName():
	return {
		title = String(_insertMediaHere.title),
		artist = String(_insertMediaHere.artist),
		license = String(_insertMediaHere.license),
		source = String(_insertMediaHere.source),
		albumPic = _insertMediaHere.albumPic
	}

func _init():
	# add auxilary audiostreamplayers for different busses
	add_child(AutoSFX)
	AutoSFX.set_bus("SoundEffect")
	
	add_child(AutoMusic)
	AutoMusic.set_bus("Music")
	
	# add timer
	add_child(startTimer)
	startTimer.one_shot = true
	startTimer.connect("timeout",self,"_on_StartTimer_timeout")
	
	# https://github.com/MightyPrinny/godot-FLMusicLib/blob/demo/global.gd
	add_child(FLMmusic)
	FLMmusic.set_gme_buffer_size(2048*5)
	
	# add Music Name Popup
	add_child(MusicNamePopup)
	MusicNamePopup.show()
	pass

func giveMe_MusicPopName(theThing):
	externalMusicPopName = theThing

# Called when the node enters the scene tree for the first time.
func _ready():
	_calibrateSecPerBeat()
	
	# https://godotengine.org/asset-library/asset/240
#	add_child(ArlezMIDI)
#	ArlezMIDI.set_max_polyphony(12)
#	ArlezMIDI.soundfont = load("res://DummyTest/dataArlez80/Aspirin-Stereo.sf2")
	
	# https://gamedev.stackexchange.com/questions/184354/add-a-sound-to-all-the-buttons-in-a-project/184363#184363
	# https://github.com/godotengine/godot-proposals/issues/1472
	# Godot pls make it a theme feature! https://github.com/godotengine/godot/issues/3608
	#add_child(ButtonSound)
	#ButtonSound.stream = load(ButtonSoundFX)
#	connect_buttons(get_tree().root)
#	get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	# Breviceps click https://freesound.org/people/Breviceps/sounds/448081/
	# Chirstopherdeep click https://freesound.org/people/Christopherderp/sounds/333041/
	pass # Replace with function body.

func _on_SceneTree_node_added(node):
#	if node is Button:
#		connect_to_button(node)
	pass

func _on_Button_pressed():
	#ButtonSound.play()
	pass

# recursively connect all buttons
func connect_buttons(root):
#	for child in root.get_children():
#		if child is BaseButton:
#			connect_to_button(child)
#		connect_buttons(child)
	pass

func connect_to_button(button):
#	button.connect("pressed", self, "_on_Button_pressed")
	pass

# Rhythm sTILEr
func _physics_process(delta):
	if AutoMusic.playing:
		song_position = AutoMusic.get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
