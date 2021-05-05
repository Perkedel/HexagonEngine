extends Control

onready var Dsegs = $VBoxContainer/DSEGs
var Dseg
onready var textEdit = $VBoxContainer/VBoxContainer3/TextEdit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Dseg = Dsegs.get_children()
	for aDseg in Dseg:
		aDseg.text = textEdit.text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	$VBoxContainer/DSEGs/DSEGLabel.size = value
	pass # Replace with function body.


func _on_HSlider2_value_changed(value):
	$VBoxContainer/DSEGs/DSEGLabel2.size = value
	pass # Replace with function body.


func _on_TextEdit_text_changed():
	for aDseg in Dseg:
		aDseg.text = textEdit.text
	pass # Replace with function body.


func _on_HSlider3_value_changed(value):
	$VBoxContainer/DSEGs/DSEGLabel3.size = value
	pass # Replace with function body.


func _on_HSlider4_value_changed(value):
	$VBoxContainer/DSEGs/DSEGLabel4.size = value
	pass # Replace with function body.
