tool
extends WindowDialog

signal method_changed( method )

export(Resource) var editing_input

func _ready():
	$LineEdit.set_text( editing_input.activation_method )
	$LineEdit2.set_text( editing_input.deactivation_method )

func _on_OkButton_pressed() -> void:
	call_deferred("hide")
	call_deferred("queue_free")

func _on_LineEdit_text_changed( new_text:String ) -> void:
	emit_signal( "method_changed", new_text )

func _on_LineEdit2_text_changed( new_text:String ) -> void:
	editing_input.deactivation_method = new_text
