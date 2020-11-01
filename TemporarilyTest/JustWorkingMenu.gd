extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var DVDItemLists :Dictionary
var DVDarrayPathLoad : PoolStringArray = []
var DVDcounter : int = 0
signal openSetting()
signal shareBootInfoJson(JsonOfIt, pathOfIt)

# Called when the node enters the scene tree for the first time.
func _ready():
	reloadAccountName()
	refreshDVDs()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func refreshDVDs():
	# documentation of "Directory"
	print("DVD Cardtridges")
	var GameDVDCardtridges = Directory.new()
	var bootFile = File.new()
	if GameDVDCardtridges.open("res://GameDVDCardtridge/") == OK:
		GameDVDCardtridges.list_dir_begin()
		var file_name = GameDVDCardtridges.get_next()
		
		while file_name != "":
			if GameDVDCardtridges.current_is_dir():
				print(file_name, " Directory")
				# GameDVDCardtridges.get_current_dir()
				if bootFile.open(GameDVDCardtridges.get_current_dir() + "/" + file_name + "/boot.json", File.READ) == OK:
					var content = parse_json(bootFile.get_as_text())
					print("\n\nContent ", String(content))
					emit_signal("shareBootInfoJson", content, bootFile.get_path())
					DVDItemLists[content.id] = content
					bootFile.close()
					pass 
				else:
					print("Werror boot file cannot open ", GameDVDCardtridges.get_current_dir() + "/", file_name + "/boot.json")
					pass
				pass
			else:
				print(file_name, " File")
				pass
			file_name = GameDVDCardtridges.get_next()
			pass
		# https://godotengine.org/asset-library/asset/157
		print("\n\nDVDs now\n", String(JSONBeautifier.beautify_json(to_json(DVDItemLists))))
		pass
	else:
		printerr("Werror cannot open GameDVDCartridged dir!!!")
		pass
	
	$ItemList.clear()
	DVDcounter = 0
	for aDVD in DVDItemLists:
		var deserve_addition = false
		if DVDItemLists.has("hidden"):
			
			if !DVDItemLists[aDVD].hidden:  # is not hidden
				deserve_addition = true
			else: # is hidden
				# Read required activation of easter eggsellent
				if aDVD.requiredEggsellents.empty():
					# No easter egg needed but it's hidden
					deserve_addition = false
				else:
					# there is easter egg required for unhide
					var current_eggs = Settingers.SettingData.Eggsellents # Dictionary
					var wantede_eggs = aDVD.requiredEggsellents # Array has
					if current_eggs.has_all(wantede_eggs):
						deserve_addition = true
					else:
						deserve_addition = false
					
					#### WILL REMOVE BY
					#### ANGLE GRINDER
					#### START DELETION
	#				var lengthRequired = wantede_eggs.length
	#				var lengthNow = 0
					# https://generalistprogrammer.com/godot/godot-for-loop-tutorial-definitive-guide-with-examples/
	#				for egg in range(lengthRequired):
	#					if current_eggs.has(wantede_eggs.egg):
	#						lengthNow += 1
	#					pass
	#				if lengthNow >= lengthRequired:
	#					deserve_addition = true
	#				else:
	#					deserve_addition = false
					#### END DELETION
					#### PAIN IS TEMPORARY
					#### GLORY IS FOREVER
					#### LOL WINTERGATAN
		else:
			deserve_addition = true
		
		if deserve_addition:
			$ItemList.add_item(DVDItemLists[aDVD].Title, load(DVDItemLists[aDVD].IconUrl))
			DVDarrayPathLoad.insert(DVDcounter, DVDItemLists[aDVD].BootThisTscene)
			DVDcounter+=1
		pass
	
	pass

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
signal ItemClickEnter(Index, pathOfThis)
func _on_ItemList_item_activated(index):
	emit_signal("ItemClickEnter",index, DVDarrayPathLoad[index])
	pass # Replace with function body.


func _on_AccountButton_pressed():
	emit_signal("openSetting")
	pass # Replace with function body.

signal loadMoreDVDsNow()
func _on_LoadMoreDVDsButton_pressed():
	emit_signal("loadMoreDVDsNow")
	pass # Replace with function body.

signal importModPCKnow()
func _on_ImportModPackButton_pressed():
	emit_signal("importModPCKnow")
	pass # Replace with function body.


func _on_ItemList_item_rmb_selected(index, at_position):
	pass # Replace with function body.


func _on_RefreshDVDbutton_pressed():
	refreshDVDs()
	pass # Replace with function body.

signal viewVRImageNow()
func _on_ViewVRImage_pressed():
	emit_signal("viewVRImageNow")
	pass # Replace with function body.
