extends Node
# Kade Engine Timing struct guys
# copy pasted by JOELwindows7
# from TimingStruct.hx

class_name TimingStruct
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var allTimings:Array #arrays of this itself nodes
var bpm:float = 0
var startBeat:float = 0
var startStep:int = 0
var endBeat:float = INF
var startTime:float = 0

var lengthe:float = INF #in beats. yeah length in beats

func newe(sBeat:float, bpme:float, eBeat:float, ofse:float):
	self.bpm = bpme
	self.startBeat = sBeat
	if eBeat != 1:
		self.endBeat = eBeat
	self.startTime = ofse
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clearTimings():
	allTimings = []

func addTiming(startBeat:float, bpm:float, endBeat:float, offset:float):
	var pog = load("res://Scripts/AutoKadeTimingStruct.gd").instantiate()
	pog.newe(startBeat,bpm,endBeat, offset)
	allTimings.append(pog)
	pass

func getTimingAtTimestamp(msTime:float) -> TimingStruct:
	for i in allTimings:
		if msTime > i.startTime  * 1000 and msTime < (i.startTime + i.lengthe) * 1000:
			return i
		pass
#	print("Apparently, " + String(msTime) + " is out of any segs")
	return null

func getTimingAtBeat(beat:float) -> TimingStruct:
	for i in allTimings:
		if i.startbeat <= beat && i.endBeat >= beat:
			return i
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
