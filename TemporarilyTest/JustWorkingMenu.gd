extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal openSetting()

# Called when the node enters the scene tree for the first time.
func _ready():
	reloadAccountName()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reloadAccountName():
	$TitleBar/AccountButton.text = Settingers.SettingData.Nama
	pass

func InitMeSelf():
	print("Init Just WOrking")
	
	$ItemList.grab_focus() #Help! doesn't work to focus the lista
	#$ItemList.grab_click_focus()
	#$HBoxContainer/PowerOffButton.grab_focus()
	pass

signal PressShutDown
func _on_PowerOffButton_pressed():
	emit_signal("PressShutDown")
	pass # Replace with function body.

export var WhichItemSelected = 0
func _on_ItemList_item_selected(index):
	WhichItemSelected = index
	pass # Replace with function body.

export var WhichItemClickEnter = 0
signal ItemClickEnter(Index)
func _on_ItemList_item_activated(index):
	emit_signal("ItemClickEnter",index)
	pass # Replace with function body.


func _on_AccountButton_pressed():
	emit_signal("openSetting")
	pass # Replace with function body.
