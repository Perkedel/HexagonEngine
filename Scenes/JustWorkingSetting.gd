extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ShowModListMenuNow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_JustWorkingSetting_confirmed():
	
	Settingers.SettingSave()
	pass # Replace with function body.


func _on_JustWorkingSetting_custom_action(action):
	pass # Replace with function body.


func _on_JustWorkingSetting_popup_hide():
	Settingers.SettingSave()
	pass # Replace with function body.


func _on_ShowModListMenu_pressed():
	emit_signal("ShowModListMenuNow")
	pass # Replace with function body.
