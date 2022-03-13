extends Button

signal char_pressed(character)

func _on_CharButton_pressed():
	emit_signal("char_pressed", text)
