extends Control

"""
- https://reddit.com/r/Shantae3DModel (Not Suitable for Wumpus) (The harsh Chapter)
- https://github.com/Perkedel/After-Church/blob/master/RAW%20files/Blender/unMixamoStick.blend (The harsh chapter)

https://github.com/Perkedel/After-Church/blob/master/RAW%20files/Blender/ZoblatosImprovement.blend
"""

export(String) var ResultPrice = "[color=#00ff00]Ideal[/color]"
export(String) var WarningText = ""
var priceNum:float = 0.0
onready var submit = $VBoxContainer/ButtonDecide/Submit
onready var priceTextLabel = $VBoxContainer/PriceTag/Harga
onready var warningTextLabel = $VBoxContainer/PriceTag/Warning
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal LevelFinish(status)
# 0 Complete
# 1 Fail
# 2 Skip


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func VerifyPrice(value):
	if value<0.0: 
		ResultPrice = "[color=#ff0000]Too Cheap[/color]"
		WarningText = "Please don't recklessly giveaway your money!"
		submit.disabled = true
	elif value == 0.0:
		ResultPrice = "[color=#00ff00]Ideal[/color]"
		WarningText = ""
		submit.disabled = false
	elif value>0.0:
		ResultPrice = "[color=#ff0000]Too Expensive[/color]"
		WarningText = "Law Violation!: Law of Soft Copy Beer, Penalty Lose Kvz Monthly UBI airdrop, & 500 more; Do not Submit unless you know what are you doing!"
		submit.disabled = false
	
	priceNum = value
	priceTextLabel.bbcode_text = "$"+String(value)+" "+ResultPrice
	warningTextLabel.text = WarningText
	pass

func _on_HSlider_value_changed(value):
	VerifyPrice(value)
	pass # Replace with function body.


func _on_Submit_pressed():
	if priceNum>0.0:
		emit_signal("LevelFinish",1)
		print("Expensivist")
	else:
		emit_signal("LevelFinish",0)
		print("Cool and good")
	pass # Replace with function body.
