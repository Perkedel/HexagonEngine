extends Window


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var zetrixViewport:SubViewport
var images
var ZetrixCheatAttempt:String

# Called when the node enters the scene tree for the first time.
func _ready():
	$ZetrixCheatCode.hide()
	$ZetrixCheatCode.text = ""
	pass # Replace with function body.

# Demo from 3D in 2D Godot official
func ReceiveZetrixViewport(getIt:SubViewport):
	zetrixViewport = getIt
	await get_tree().idle_frame
	await get_tree().idle_frame
	images = zetrixViewport.get_texture()
	$ZetrixTextureResult.texture = images
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zetrixViewport:
		#images = zetrixViewport.get_texture().get_data()
		#images.flip_y()
		#$ZetrixTextureResult.texture = images
		pass
	
	if visible:
		if Input.is_key_pressed(KEY_A):
			$ZetrixCheatCode.show()
			pass
		pass
	pass

func _input(event):
	match(event):
		InputEventKey:
			match(event.is_pressed()):
				KEY_A:
					if not visible:
						$ZetrixCheatCode.show()
						pass

func _on_ZetrixCheatCode_text_entered(new_text):
	print("Attempt Zetrix cheatcode ",new_text)
	$ZetrixCheatCode.hide()
	ZetrixCheatAttempt = new_text
	if ZetrixCheatAttempt.capitalize() == String("ri").capitalize():
		Settingers.addEggsellent("WalkIntoTheGame",true)
		#$ZetrixMonitorSpeaker.stream = load("res://Audio/EfekSuara/CopyrightInfringement/Microsoft/tada.wav")
		$ZetrixMonitorSpeaker.play()
		pass
	pass # Replace with function body.
