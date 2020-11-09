extends Node
# Loads Mods of PCK files you guys created

var modLists : Dictionary
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal modLoaded()

func loadAllMods():
	modLists = Settingers.getModPCKs()
	print(String(modLists))
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
