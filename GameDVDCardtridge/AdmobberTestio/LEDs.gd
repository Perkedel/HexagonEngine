extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum StatusLED {LED_OFF=-1, LED_OK=0, LED_FAILED=1}
@export (PackedInt32Array) var StatusSet = [-1,-1,-1]
@export (int) var TestStatusCycle = -1
@export (bool) var TestModeOn = false

# Called when the node enters the scene tree for the first time.

func TestLEDs():
	TestModeOn = true
	pass

func PrepareLEDs():
	$Banner.self_modulate = Color.BLACK
	$Interstitial.self_modulate = Color.BLACK
	$RewardedVideo.self_modulate = Color.BLACK
	TestLEDs()
	pass

func SetStatus(nodeName:String, statusEnum):
	#var nodeing = get_node(nodeName)
	var nodeing
	var select
	if nodeName == String("Interstitial"):
		nodeing = $Interstitial
		select = 1
		pass
	elif nodeName == String("Banner"):
		nodeing = $Banner
		select = 0
		pass
	elif nodeName == String("RewardedVideo"):
		nodeing = $RewardedVideo
		select = 2
		pass
	else:
		nodeing = $Banner
		select = 0
		pass
	
	if statusEnum == StatusLED.LED_OFF || statusEnum == -1:
		#nodeing.self_modeulate = Color.black
		pass
	elif statusEnum == StatusLED.LED_OK || statusEnum == 0:
		#nodeing.self_modeulate = Color.green
		pass
	elif statusEnum == StatusLED.LED_FAILED || statusEnum == 1:
		#nodeing.self_modeulate = Color.red
		pass
	else:
		#nodeing.self_modeulate = Color.yellowgreen
		pass
	
	StatusSet[select] = statusEnum
	pass

func _ready():
	PrepareLEDs()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !TestModeOn:
		for i in 3:
			if StatusSet[i] == -1:
				get_child(i).self_modulate = Color.BLACK
				pass
			elif StatusSet[i]  == 0:
				get_child(i).self_modulate = Color.GREEN
				pass
			elif StatusSet[i]  == 1:
				get_child(i).self_modulate = Color.RED
				pass
			else:
				get_child(i).self_modulate = Color.YELLOW_GREEN
				pass
			pass
		pass
	else:
		if $RemainerCycle.is_stopped():
			$RemainerCycle.start()
			$Cycler.start()
			pass
		else:
			pass
		pass
		
		for i in 3:
			if TestStatusCycle == -1:
				get_child(i).self_modulate = Color.BLACK
				pass
			elif TestStatusCycle  == 0:
				get_child(i).self_modulate = Color.GREEN
				pass
			elif TestStatusCycle  == 1:
				get_child(i).self_modulate = Color.RED
				pass
			else:
				get_child(i).self_modulate = Color.YELLOW_GREEN
				pass
			pass
		pass
	pass


func _on_RemainerCycle_timeout():
	$Cycler.stop()
	TestModeOn = false
	pass # Replace with function body.


func _on_Cycler_timeout():
	TestStatusCycle +=1
	if TestStatusCycle > 1:
		TestStatusCycle = -1
		pass
	pass # Replace with function body.
