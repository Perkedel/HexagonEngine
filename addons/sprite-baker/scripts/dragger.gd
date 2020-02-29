tool
extends VSeparator

export(StyleBoxLine) var dragger_stylebox: StyleBoxLine
export(StyleBoxLine) var dragger_hover_stylebox: StyleBoxLine





func _on_mouse_entered() -> void:
	add_stylebox_override("separator", dragger_hover_stylebox)


func _on_mouse_exited() -> void:
	add_stylebox_override("separator", dragger_stylebox)
