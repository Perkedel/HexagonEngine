extends Node

# steal from Friday Night Funkin lol
# https://www.newgrounds.com/portal/view/770371
# https://github.com/ninjamuffin99/Funkin
# https://github.com/KadeDev/Kade-Engine
# https://github.com/Perkedel/Kaded-fnf-mods
# see source/Conductor.hx

class BPMChangeEvent:
	var stepTime:int
	var songTime:float
	var bpm:float

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bpm:float = 100
var crochet:float = ((60/bpm) * 1000) #beats in millisecond
var stepCrochet:float = crochet / 4; #steps in millisecond
var songPosition:float
var lastSongPos:float
var offset:float

var safeFrames:int = 10;
var safeZoneOffset:float = floor((safeFrames /60) * 1000) # is calculated in _ready(), is frame in millisecond
var timeScale:float = safeZoneOffset / 166

var bpmChangeMap:Array #of instance BPMChangeEvent class

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recalculateTiming():
	safeFrames = 10 # or setting variable of Safe Frames
	safeZoneOffset = floor((safeFrames / 60) * 1000)
	timeScale = safeZoneOffset / 166

func mapBPMChanges(): # put MediaCardtridge dictionary here
	pass


func changeBPM(newBPM:float, recalcLength = true):
	bpm = newBPM
	
	crochet = ((60/bpm)*1000)
	stepCrochet = crochet / 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
