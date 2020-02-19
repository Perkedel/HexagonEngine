extends Node

export (bool) var isPlayingGameNow = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ImplementTheseCustomNextMenu():
	#Todo: next menu custom and setting area custom category
	pass

func ActivateStuffs():
	$GameField/GamePlay/Spawnering.Activated = true
	$Bekgronding.EnableSpeed = true
	$"UI".BehaveStartGaming()
	pass

func StartGamingNow():
	#noweks
	ActivateStuffs()
	isPlayingGameNow = true
	pass

func StopGamingNow():
	$"UI".BehaveStopGaming()
	ResumeGameNow()
	isPlayingGameNow = false
	pass

func PauseGameNow():
	Singletoner.isGamePaused = true
	get_tree().paused = true
	pass

func ResumeGameNow():
	Singletoner.isGamePaused = false
	get_tree().paused = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	ImplementTheseCustomNextMenu()
	$Bekgronding.EnableSpeed = false
	pass # Replace with function body.

# UI designed by Billy Husada

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_UI_AboutCreditNow():
	pass # Replace with function body.


func _on_UI_ChangeDVDNow():
	pass # Replace with function body.


func _on_UI_ExitNow():
	pass # Replace with function body.


func _on_UI_InstructionNow():
	pass # Replace with function body.


func _on_UI_PlayNow():
	StartGamingNow()
	pass # Replace with function body.


func _on_UI_SettingNow():
	pass # Replace with function body.
