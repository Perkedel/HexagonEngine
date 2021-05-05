extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SettingersPath = "Nama"
var settingLoaded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(get_tree().create_timer(.01),"timeout")
	#reload()
	pass # Replace with function body.

func reload():
	
	print("Welcome, ", String(Settingers.get_setting(SettingersPath)))
	$LineEdit.text = Settingers.get_setting(SettingersPath)
	settingLoaded = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_entered(new_text):
	print("Set new name to ", new_text)
	if settingLoaded:
		Settingers.setNama(new_text)
	Settingers.SettingSave()
	pass # Replace with function body.


func _on_LineEdit_text_changed(new_text):
	print("typing new name: ", new_text)
	if settingLoaded:
		Settingers.setNama(new_text)
	pass # Replace with function body.


func _on_NamaSetting_visibility_changed():
	settingLoaded = false
	yield(get_tree().create_timer(.01),"timeout")
	reload()
	pass # Replace with function body.
