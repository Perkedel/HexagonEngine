extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var modPCKs:Dictionary = Settingers.getModPCKs()
var textModList:String
var loaded = false

func Load():
	textModList = JSONBeautifier.beautify_json(to_json(modPCKs))
	$VBoxContainer/TempTextModList.text = textModList
	loaded = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(get_tree().create_timer(.001),"timeout")
	#Load()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SaveClose_pressed():
	modPCKs = parse_json(textModList)
	Settingers.setModPCKs(modPCKs)
	print("Now ModsPCKs\n", JSONBeautifier.beautify_json(to_json(Settingers.getModPCKs())))
	hide()
	pass # Replace with function body.


func _on_TempTextModList_text_changed():
	textModList = $VBoxContainer/TempTextModList.text
	pass # Replace with function body.


func _on_JustModListToLoad_visibility_changed():
	loaded = false
	Load()
	pass # Replace with function body.
