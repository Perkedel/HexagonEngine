@tool
extends Resource
class_name MediaCardtridge
# Damn it is was supposed to be named Media Cardtridge

#resource_name = "Music Cardtridge"
@export var albumPic: Texture2D = load("res://Sprites/MavrickleIcon.png")
@export var title: String = "MediaCardtridge"
@export var artist: String = "JOELwindows7"
@export var license: String = "CC4.0-BY-SA"
@export var tempo: float = 120.0
@export var timeMeasures: int = 4
@export var source:Array = ["https://cointr.ee/joelwindows7","https://odysee.com/@JOELwindows7"] # (Array,String)
@export var Audios:Array # (Array,AudioStream)
@export var Videos:Array # (Array,VideoStream)
@export var MIDIfiles:Array # (Array,String)
@export var sTILEStepsFile: String # Rhythm JSON file
@export var coreEvents: Dictionary # tempo, time measure changes

func get_audio(which:int) -> AudioStream:
	return Audios[which]
	pass

func get_video(which:int) -> VideoStream:
	return Videos[which]

func get_midi(which:int) -> String:
	return MIDIfiles[which]

func get_tempo() -> float:
	return tempo
