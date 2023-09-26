# XRController Midi Player for Godot 4.0 by Cyberrebell
# MIT License
extends Node

class_name XRControllerMidiPlayer

class Note:
	var note : int
	var duration : int = -1
	var start_time : int
	
	func _init(note : int, start_time : int):
		note = note
		start_time = start_time
	
	func end(end_time : int):
		duration = end_time - start_time

@export var midi_file : String = "res://music.mid"
@export var xr_interfaces : Array[XRNode3D]
@export var amplitude : float = 0.25
@export var play_speed : float = 1.0
@export var overlap_tracks : bool = false

var tracks : Array
var player_time : int = -1
var playing : bool = false
var speed_factor : float

func play() -> void:
	playing = _init_tracks()
	var interface_tracks : Array[Array] = _build_interfaces_tracks_map()
	_trim_track_overlaps(interface_tracks)
	player_time = 0
	while playing:
		var next_note = null
		var track_consumption = _create_track_consumption()
		for i in range(0, xr_interfaces.size()):
			for t in interface_tracks[i]:
				var consume : bool = track_consumption[t] == 0
				for note in tracks[t]:
					if note.start_time <= player_time:
						xr_interfaces[i].trigger_haptic_pulse("haptic", _calculate_fequency(note.note), amplitude, note.duration * speed_factor, 0.0)
						if consume:
							track_consumption[t] += 1
					elif not next_note is Note or note.start_time <= next_note.start_time:
						next_note = note
					else:
						break
		_execute_track_consumption(track_consumption)
		if next_note is Note:
			await get_tree().create_timer((next_note.start_time - player_time) * speed_factor).timeout
			player_time = next_note.start_time
		else:
			break

func stop() -> void:
	playing = false

func _init_tracks() -> bool:
	tracks = []
	var smf = SMF.new()
	var smf_data = smf.read_file(midi_file).data
	if smf_data == null:
		push_error("XRControllerMidiPlayer failed to open file " + midi_file)
		return false
	var tempo = 400000
	for track in smf_data.tracks:
		var notes : Array = []
		for timeframe in track.events:
			var event = timeframe.event
			match event.type:
				SMF.MIDIEventType.note_on:
					notes.push_back(Note.new(event.note, timeframe.time))
				SMF.MIDIEventType.note_off:
					var notes_to_end = notes.filter(func(note : Note): return note.note == event.note and note.duration == -1)
					if notes_to_end.size() > 0:
						notes_to_end[0].end(timeframe.time)
				SMF.MIDIEventType.system_event:
					match event.args.type:
						SMF.MIDISystemEventType.set_tempo:
							tempo = event.args.bpm
		if len(notes) > 0:
			tracks.push_back(notes)
	speed_factor = tempo / (smf_data.timebase * 1000000.0 * play_speed)
	return true

func _trim_track_overlaps(interface_tracks : Array[Array]) -> void:
	for it in interface_tracks:
		var time : int = 0
		while true:
			var current_notes = []
			var next_note_start = null
			for t in it:
				for n in range(0, tracks[t].size()):
					if tracks[t][n].start_time == time:
						current_notes.append(tracks[t][n])
					elif tracks[t][n].start_time > time:
						if next_note_start == null or tracks[t][n].start_time < next_note_start:
							next_note_start = tracks[t][n].start_time
						break
			if next_note_start == null:
				break
			for note in current_notes:
				note.duration = (next_note_start - note.start_time) - 1
			time = next_note_start

func _build_interfaces_tracks_map() -> Array:
	var map = []
	for t in range(0, tracks.size()):
		if t < xr_interfaces.size():
			map.append([t])
		elif overlap_tracks:
			map[t % xr_interfaces.size()].append(t)
	if map.size() < xr_interfaces.size():
		for i in range(tracks.size(), xr_interfaces.size()):
			map.append([i % tracks.size()])
	return map

func _create_track_consumption() -> Array:
	var track_consumption = []
	for t in range(0, tracks.size()):
		track_consumption.push_back(0)
	return track_consumption

func _execute_track_consumption(track_consumption : Array) -> void:
	for c in range(0, track_consumption.size()):
		for i in range(0, track_consumption[c]):
			tracks[c].pop_front()

func _calculate_fequency(note : int) -> float:
	return 440 * pow(2, (note - 69) / 12.0)
