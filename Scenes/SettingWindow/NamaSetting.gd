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
	
	print("Welcome, ", String(Settingers.SettingData[SettingersPath]))
	$LineEdit.text = Settingers.SettingData[SettingersPath]
	settingLoaded = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_entered(new_text):
	if settingLoaded:
		Settingers.SettingData[SettingersPath] = new_text
	# Settingers.SettingSave()
	pass # Replace with function body.


func _on_LineEdit_text_changed(new_text):
	if settingLoaded:
		Settingers.SettingData[SettingersPath] = new_text
	pass # Replace with function body.


func _on_NamaSetting_visibility_changed():
	settingLoaded = false
	reload()
	pass # Replace with function body.
