extends Node
# Loads Mods of PCK files you guys created

var modLists : Dictionary
var modsFolder : Dictionary
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal modLoaded()
signal modFolderLoaded()

func loadAllModsFolder():
	var locate = OS.get_executable_path() + "/ModPCK"
	
#	var dirNow = DirAccess.new()
	var dirNow:DirAccess
	var modInFolder
	
	var try = dirNow.open(locate)
	if try == OK:
		dirNow.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		modInFolder = dirNow.get_next()
		while modInFolder != "":
			if dirNow.current_is_dir():
				print("Dir found")
				pass
			else:
				modsFolder[modInFolder] = {
					Patho=locate+modInFolder,
					Replaceo=false,
					#fromFolder=true
				}
				pass
			modInFolder = dirNow.get_next()
			pass
		pass
	else:
		printerr("Werror "+ try.to_string() +" cannot open ModPCK file!\ndid you deleted it?")
		pass
	pass

func wellLoadModsFolder():
	loadAllModsFolder()
#	print(String(modsFolder.))
	print("\n\nMods Folder:")
	
	for modu in modsFolder:
		print(String(modu))
		#print(modu)
		if ProjectSettings.load_resource_pack(modLists[modu].Patho,modLists[modu].Replaceo):
			print(modLists[modu].Patho, " Success")
		else:
			print(modLists[modu].Patho, " Failed")
		pass
	#print("\n\n\n Warning! Godot FileDialog bug!\nIf you load mod PCK resource pack while a FileDialog instance is still there on a node somewhere, the FileDialog access res:// is unable to see those newly imported files! you must kill FileDialog instance and then readd fresh one again. the system however can found this file no problem.")
	
	emit_signal("modFolderLoaded")
	pass

func loadAllMods():
	wellLoadModsFolder()
	modLists = Settingers.getModPCKs()
#	print(String(modLists.values()))
	print("\n\nMods List:")
	
	# https://www.codingcommanders.com/godot/gdscript-loops.html
	# bug for in loop of Dictionary, did not grab the data inside the dictionary
	# only the title of it
	# https://gdscript.com/looping workaround
	for modu in modLists:
		print(String(modu))
		#print(modu)
		if ProjectSettings.load_resource_pack(modLists[modu].Patho,modLists[modu].Replaceo):
			print(modLists[modu].Patho, " Success")
		else:
			print(modLists[modu].Patho, " Failed")
		pass
	print("\n\n\n Warning! Godot FileDialog bug!\nIf you load mod PCK resource pack while a FileDialog instance is still there on a node somewhere, the FileDialog access res:// is unable to see those newly imported files! you must kill FileDialog instance and then readd fresh one again. the system however can found this file no problem.")
	#yield(get_tree().create_timer(.1),"timeout")
	emit_signal("modLoaded")
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#loadAllMods()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
