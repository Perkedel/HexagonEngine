extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var DVDListCachePath = "user://Pengaturan/DaftarDVD.json"
var DVDItemLists :Dictionary
var shownDVDItemLists : Dictionary
var DVDarrayPathLoad : PoolStringArray = []
var DVDExclusiveBootStatement : PoolIntArray = []
var DVDcounter : int = 0
onready var preSelImag = preload("res://Sprites/ConsoleHoverEmpty.png")
onready var preLauImag = preload("res://Sprites/ConsoleLaunchEmpty.png")
signal openSetting()
signal shareBootInfoJson(JsonOfIt, pathOfIt)
signal updateSelectionAssets(hoverImage,launchImage,hoverAudio,launchAudio)

# Called when the node enters the scene tree for the first time.
func _ready():
	loadDVDListCache()
	reloadAccountName()
	#refreshDVDs()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func loadDVDListCache():
	DVDItemLists = Settingers.getDVDListCache()
	pass

func saveDVDListCache():
	Settingers.setDVDListCache(DVDItemLists)
	Settingers.SettingSave()
	pass

signal DVDListRefreshed()
func refreshDVDs():
	# documentation of "Directory"
	print("DVD Cardtridges")
	var GameDVDCardtridges = Directory.new()
	var bootFile = File.new()
	if GameDVDCardtridges.open("res://GameDVDCardtridge/") == OK:
		# Basic DVD loading
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
		if DVDItemLists[aDVD].has("hidden"):
			
			if !DVDItemLists[aDVD].hidden:  # is not hidden
				print(aDVD, " is not hidden\n")
				deserve_addition = true
			else: # is hidden
				# Read required activation of easter eggsellent
				if DVDItemLists[aDVD].has("requiredEggsellents"):
					if DVDItemLists[aDVD].requiredEggsellents.empty():
						# No easter egg needed but it's hidden
						print(aDVD, " is hidden, empty eggsellent\n")
						deserve_addition = false
					else:
						# there is easter egg required for unhide
						var current_eggs = Settingers.fetchEggsellentAll() # Dictionary
						var wantede_eggs = DVDItemLists[aDVD].requiredEggsellents # Array has
						if current_eggs.has_all(wantede_eggs):
							print(aDVD, " eggsellent is met, show it!\n")
							deserve_addition = true
						else:
							print(aDVD, " eggsellent is unmet, no show.\n")
							deserve_addition = false
				else:
					print(aDVD, " is hidden absolutely\n")
					deserve_addition = false
					pass
					
					#### WILL REMOVE BY
					#### ANGLE GRINDER
					#### START DELETION
					## but we don't recycle this code to the plastic containers.
					#### END DELETION
					#### PAIN IS TEMPORARY
					#### GLORY IS FOREVER
					#### LOL WINTERGATAN
		else:
			print(aDVD, " has no Hidden here, show it anyway\n")
			deserve_addition = true
		
		if deserve_addition:
			var TitleAppend = DVDItemLists[aDVD].Title
			if DVDItemLists[aDVD].has("ExclusiveBoot"):
				var checko = bool(DVDItemLists[aDVD].ExclusiveBoot)
				if checko:
					TitleAppend += " (Exclusive Boot)"
				pass
				DVDExclusiveBootStatement.insert(DVDcounter,int(checko))
			else:
				DVDExclusiveBootStatement.insert(DVDcounter,0)
			$ItemList.add_item(TitleAppend, load(DVDItemLists[aDVD].IconUrl))
			DVDarrayPathLoad.insert(DVDcounter, DVDItemLists[aDVD].BootThisTscene)
			shownDVDItemLists[aDVD] = DVDItemLists[aDVD]
			DVDcounter+=1
		pass
	saveDVDListCache()
	emit_signal("DVDListRefreshed")
	pass

func reloadAccountName():
	$TitleBar/AccountButton.text = Settingers.getNama()
	pass

func InitMeSelf():
	print("Init Just WOrking")
	
	$ItemList.grab_focus() #Help! doesn't work to focus the lista
	#$ItemList.grab_click_focus()
	#$HBoxContainer/PowerOffButton.grab_focus()
	pass

func iHoverThisDVD():
	AutoSpeaker.playButtonHover()
	var keying = shownDVDItemLists.keys()
	var checkering : Dictionary = shownDVDItemLists[keying[WhichItemSelected]]
	print("Hovered DVD ", keying[WhichItemSelected])
	var selPath:String
	var lauPath:String
	var selImag : Texture 
	var lauImag : Texture
	if checkering.has("HoveredImage"):
		selPath = checkering["HoveredImage"] 
		if(selPath == ""):
			selImag = preSelImag
			pass
		else:
			selImag = load(checkering["HoveredImage"])
	else:
		selImag = preSelImag
	
	if checkering.has("SelectedImage"):
		lauPath = checkering["SelectedImage"]
		if(lauPath == ""):
			lauImag = preLauImag
			pass
		else:
			lauImag = load(checkering["SelectedImage"])
	else:
		lauImag = preLauImag
	
	emit_signal("updateSelectionAssets",selImag,lauImag,"","")
	pass

signal PressShutDown
func _on_PowerOffButton_pressed():
	emit_signal("PressShutDown")
	pass # Replace with function body.

export var WhichItemSelected = 0
func _on_ItemList_item_selected(index):
	
	WhichItemSelected = index
	iHoverThisDVD()
	pass # Replace with function body.

export var WhichItemClickEnter = 0
signal ItemClickEnter(Index, pathOfThis, ExclusiveBootStatement)
func _on_ItemList_item_activated(index):
	AutoSpeaker.playButtonClick()
	emit_signal("ItemClickEnter",index,DVDarrayPathLoad[index], bool(DVDExclusiveBootStatement[index]))
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
