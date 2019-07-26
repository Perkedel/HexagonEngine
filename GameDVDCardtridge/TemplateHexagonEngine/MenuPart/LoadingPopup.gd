extends Popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float, 0, 100) var ProgressMeterValue
export(String) var ProgressWording
var Dots = "......."
export(bool) var LoadingCompleted = false
export(Color) var IncompleteLoadingColor
export(Color) var CompleteLoadingColor
export(float,0,360) var HourglassRotateDegree

# Called when the node enters the scene tree for the first time.
func _ready():
	$DotFramePerSec.start(.5)
	pass # Replace with function body.

func SpawnLoading():
	popup()
	DeCompleteTheLoadingNow()
	pass

func DespawnLoading():
	hide()
	pass

func DeCompleteTheLoadingNow():
	LoadingCompleted = false
	#$LoadingAnimates.play("GravityHourGlassRotate")
	$Timerout.stop()
	$DotFramePerSec.start()
	$HourglassFramesPerSec.start()
	ProgressWording = "Now Loading!"
	pass

func CompleteTheLoadingNow():
	LoadingCompleted = true
	#$LoadingAnimates.play("GravityHourGlassStonp")
	$Timerout.start()
	$DotFramePerSec.stop()
	$HourglassFramesPerSec.stop()
	ProgressWording = "Loading Completed!"
	pass

func UpdateDots():
	Dots += "."
	if Dots == "........":
		Dots = ""
		pass
	pass

func RotateHourglass():
	HourglassRotateDegree += 2
	if HourglassRotateDegree >= 360:
		HourglassRotateDegree = 0
		pass    
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxContainer/VBoxContainer/ProgressBar.value = ProgressMeterValue
	$HBoxContainer/VBoxContainer/LoadingHintWord.text = ProgressWording + Dots
	
	if Input.is_key_pressed(KEY_5):
		SpawnLoading()
		pass
	
	if Input.is_key_pressed(KEY_4):
		CompleteTheLoadingNow()
		pass
	
	if LoadingCompleted:
		$HBoxContainer/VBoxContainer/ProgressBar.self_modulate = CompleteLoadingColor
		
		pass
	else:
		$HBoxContainer/VBoxContainer/ProgressBar.self_modulate = IncompleteLoadingColor
		pass
	
	$HBoxContainer/GravityHourGlass.set_rotation_degrees(HourglassRotateDegree)
	pass


func _on_Timerout_timeout():
	#$LoadingAnimates.stop()
	hide()
	pass # Replace with function body.


func _on_DotFramePerSec_timeout():
	UpdateDots()
	pass # Replace with function body.


func _on_HourglassFramesPerSec_timeout():
	RotateHourglass()
	pass # Replace with function body.
