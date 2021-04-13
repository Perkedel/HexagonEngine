extends Spatial

onready var MainSpk = $Speaker
onready var SubSpk = $Subwoofer
onready var MainSpkButton = $SpeakerPanel/VBoxContainer/SpeakerContains/MainSpeaker
onready var SubSpkButton = $SpeakerPanel/VBoxContainer/SpeakerContains/LFESpeaker
onready var labeler = $SpeakerPanel/VBoxContainer/Labelrer
var speakerCount = 0
var subwooferCount = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for eachButton in range(MainSpkButton.get_child_count()):
		MainSpkButton.get_child(eachButton).connect("pressed",MainSpk.get_child(eachButton),"test_me")
		print("Connect Speaker " + String(eachButton))
		speakerCount+=1
	for eachButton in range(SubSpkButton.get_child_count()):
		SubSpkButton.get_child(eachButton).connect("pressed",SubSpk.get_child(eachButton),"test_me")
		print("Connect Subwoofer " + String(eachButton))
		subwooferCount+=1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	labeler.text = "Speaker Test " + String(speakerCount) + "." + String(subwooferCount)
	pass
