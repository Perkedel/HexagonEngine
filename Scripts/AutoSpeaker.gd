extends AudioStreamPlayer

var FLMmusic = FLMusicLib.new()
var ButtonSound = AudioStreamPlayer.new()
var ButtonSoundFX : String = "res://Audio/EfekSuara/448081__breviceps__tic-toc-click.wav"
#var ArlezMIDI = MidiPlayer.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# https://godotforums.org/discussion/22756/button-sound

# Called when the node enters the scene tree for the first time.
func _ready():
	set_bus("SoundEffect")
	
	# https://github.com/MightyPrinny/godot-FLMusicLib/blob/demo/global.gd
	add_child(FLMmusic)
	FLMmusic.set_gme_buffer_size(2048*5)
	
	# https://godotengine.org/asset-library/asset/240
#	add_child(ArlezMIDI)
#	ArlezMIDI.set_max_polyphony(12)
#	ArlezMIDI.soundfont = load("res://DummyTest/dataArlez80/Aspirin-Stereo.sf2")
	
	# https://gamedev.stackexchange.com/questions/184354/add-a-sound-to-all-the-buttons-in-a-project/184363#184363
	# https://github.com/godotengine/godot-proposals/issues/1472
	# Godot pls make it a theme feature! https://github.com/godotengine/godot/issues/3608
	add_child(ButtonSound)
	ButtonSound.stream = load(ButtonSoundFX)
#	connect_buttons(get_tree().root)
#	get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	# Breviceps click https://freesound.org/people/Breviceps/sounds/448081/
	# Chirstopherdeep click https://freesound.org/people/Christopherderp/sounds/333041/
	pass # Replace with function body.

func _on_SceneTree_node_added(node):
	if node is Button:
		connect_to_button(node)

func _on_Button_pressed():
	ButtonSound.play()

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button):
	button.connect("pressed", self, "_on_Button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
