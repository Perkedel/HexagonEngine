tool
extends Resource
class_name MediaCardtridge
# Damn it is was supposed to be named Media Cardtridge

#resource_name = "Music Cardtridge"
export(Texture) var albumPic = load("res://Sprites/MavrickleIcon.png")
export(String) var title = "MediaCardtridge"
export(String) var artist = "JOELwindows7"
export(String) var license = "CC4.0-BY-SA"
export(float) var tempo = 120.0
export(int) var timeMeasures = 4
export(Array,String) var source = ["https://cointr.ee/joelwindows7","https://odysee.com/@JOELwindows7"]
export(Array,AudioStream) var Audios
export(Array,VideoStream) var Videos
export(Array,String) var MIDIfiles
export(String) var sTILEStepsFile # Rhythm JSON file
export(Dictionary) var coreEvents # tempo, time measure changes

func get_audio(which:int) -> AudioStream:
	return Audios[which]
	pass

func get_video(which:int) -> VideoStream:
	return Videos[which]

func get_midi(which:int) -> String:
	return MIDIfiles[which]

func get_tempo() -> float:
	return tempo
