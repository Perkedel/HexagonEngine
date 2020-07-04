tool
extends LineEdit

var previousCaretPosition : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	placeholder_text = String(0)



func _on_LineEdit_text_changed(new_text):
	text = String(int(new_text))
	print(caret_position)
	if caret_position >= text.length():
		caret_position = text.length()
	else:
		caret_position = previousCaretPosition + 1
		
	previousCaretPosition = caret_position


#func _on_LineEdit_text_entered(new_text):
#	print("entered "+new_text)
#
#
#func _on_LineEdit_focus_entered():
#		print(caret_position)
#
#
#func _on_LineEdit_gui_input(event):
#	if event is InputEventMouseMotion:
#		pass
#	else:
#		print(event)
#		print(caret_position)
#
#
#	if event is InputEventKey:
#		if event.pressed:
#			print("pressed")


func _on_LineEdit_gui_input(event):
	previousCaretPosition = caret_position
