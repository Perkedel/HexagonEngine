tool
extends LineEdit

func _ready() -> void:
	assert(connect("text_entered", self, "_on_text_entered") == OK)
	assert(connect("focus_exited", self, "_on_focus_exited") == OK)


func _text_entered(_new_text: String) -> void:
	pass


func _on_text_entered(new_text: String) -> void:
	_text_entered(new_text)


func _on_focus_exited() -> void:
	_text_entered(self.text)
