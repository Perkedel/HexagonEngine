extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ReloadNow
signal PauseNow
signal PrevWeponNow
signal NextWeponNow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PauseButton_pressed():
	emit_signal("PauseNow")
	pass # Replace with function body.


func _on_ReloadButton_pressed():
	emit_signal("ReloadNow")
	pass # Replace with function body.


func _on_PrevWepon_pressed():
	emit_signal("PrevWeponNow")
	pass # Replace with function body.


func _on_NextWepon_pressed():
	emit_signal("NextWeponNow")
	pass # Replace with function body.
