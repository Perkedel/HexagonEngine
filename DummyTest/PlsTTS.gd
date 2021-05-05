extends Control

onready var TextToSpeak = $HBoxContainer/Controlings/TextEdit
onready var SpeakButton = $HBoxContainer/Controlings/SpeakNow
onready var SelectVoiceDropdown = $HBoxContainer/Controlings/Dropdowns/ChooseVoice
var chosenEngine:int = 0
var chosenVoice:String
var textContains:String
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func DoSpeak():
	match(chosenEngine):
		0:
			Tts.speak(textContains)
			pass
		1:
			var Command = "flite "
			var out = []
			print(Command)
			
			OS.execute("flite",["'{textToSay}'".format({
				textToSay = textContains
			}),"-voice",chosenVoice],true,out)
			
#			OS.execute("flite",["-t '{textToSay}'".format({
#				textToSay = textContains,
#			})],true,out)
			
#			OS.execute("flite",["-t '{textToSay}'".format({
#				textToSay = textContains,
#			}),"-voice '{VoiceName}'".format({
#				VoiceName = chosenVoice,
#			})],true,out)
#			OS.execute("flite",["-t '{textToSay}' ".format(
#				{
#					textToSay = textContains,
#				}
#			)],true,out)
#			OS.execute("flite -t '{textToSay}'".format({
#				textToSay = textContains,
#				VoiceName = chosenVoice,
#			}),[],true,out)
			print(String(out))
			pass
		_:
			Tts.speak(textContains)
			pass
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	textContains = TextToSpeak.text
	chosenVoice = SelectVoiceDropdown.text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpeakNow_pressed():
	DoSpeak()
	pass # Replace with function body.


func _on_TextEdit_text_changed():
	textContains = TextToSpeak.text
	pass # Replace with function body.


func _on_ChooseEngine_item_selected(index):
	chosenEngine = index
	pass # Replace with function body.


func _on_ChooseVoice_text_changed(new_text):
	chosenVoice = new_text
	pass # Replace with function body.
