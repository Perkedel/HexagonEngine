extends Node

@export (bool) var isPlayingGameNow = false
enum QuitMode{MainMenuTO,QuitTO,ChangeDVDTO}
@export (int) var SelectQuitMode

@export (float,0,100) var HealthPoint = 100
@export (float) var ScoreRightNow
@export (float) var HighScoreDisk
@export (String) var SaveFile = ""

@export (PackedScene) var BulletSceneFile = load("res://GameDVDCardtridge/ParlorClassic/Tscene/Peluru.tscn")

var MousePosition
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func SFXnow(streamFilePath:String):
	$Speakering.stream = load(streamFilePath)
	$Speakering.play()
	pass

func LoadTheGame():
	#todo open file of save data
	pass

func SaveTheGame():
	pass

func BekgronWasHit():
	print("Bekgronding was hit")
	Ouch()
	pass

func Ouch():
	HealthPoint -= 10
	SFXnow("res://GameDVDCardtridge/ParlorClassic/Audio/341243__sharesynth__hurt02.wav")
	pass

func PleaseHealth(much):
	pass

func SpawnBullet(positione:Vector2):
	var InstanceBullet = BulletSceneFile.instantiate()
	var WeponSounding = InstanceBullet.EmitThisSoundSpeaker.instantiate()
	InstanceBullet.position = positione
	WeponSounding.position = positione
	
	WeponSounding.stream = load("res://GameDVDCardtridge/ParlorClassic/Audio/450854__kyles__gun-lee-enfield-303-rifle-fire-shot.wav")
	#$GameField/GamePlay/Bullets.add_child(InstanceBullet)
	$GameField/GamePlay/Targets.add_child(InstanceBullet)
	if isPlayingGameNow:
		#SFXnow("res://GameDVDCardtridge/ParlorClassic/Audio/450854__kyles__gun-lee-enfield-303-rifle-fire-shot.wav")
		$GameField/GamePlay/Targets.add_child(WeponSounding)
		pass
	pass

func ImplementTheseCustomNextMenu():
	#Todo: next menu custom and setting area custom category
	pass

func InitScronchInternal():
	for i in $"GameField/GamePlay/Targets".get_child_count():
		$"GameField/GamePlay/Targets".get_child(i).queue_free()
		pass
	pass

func ActivateStuffs():
	#$GameField/GamePlay/Spawnering.Activated = true
	var Spawnereres = $"GameField/GamePlay/Spawnerers"
	for i in Spawnereres.get_child_count():
		Spawnereres.get_child(i).TargetNode = $GameField/GamePlay/Targets
		Spawnereres.get_child(i).Activated = true
		pass
	$Bekgronding.EnableSpeed = true
	InitScronchInternal()
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

func GameOverNow():
	#to do spawn dialog gameover when game is over
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


func _input(event):
	MousePosition = $GameField.get_global_mouse_position()
	if event is InputEventMouseMotion:
		#MousePosition = event.relative
		pass
	elif event is InputEventMouseButton:
		if event.pressed:
			#SpawnBullet(event.position)
			
			SpawnBullet(MousePosition)
			pass
		pass
	pass




func _on_UI_AboutCreditNow():
	pass # Replace with function body.


func _on_UI_ChangeDVDNow():
	SelectQuitMode = 2
	pass # Replace with function body.


func _on_UI_ExitNow():
	SelectQuitMode = 1
	pass # Replace with function body.


func _on_UI_InstructionNow():
	pass # Replace with function body.

func _on_UI_ShopButton():
	pass # Replace with function body.

func _on_UI_PlayNow():
	StartGamingNow()
	pass # Replace with function body.


func _on_UI_SettingNow():
	pass # Replace with function body.


func _on_UI_YesPlease():
	if SelectQuitMode == 0:
		StopGamingNow()
		pass
	elif SelectQuitMode == 1:
		emit_signal("Shutdown_Exec")
		pass
	elif SelectQuitMode == 2:
		emit_signal("ChangeDVD_Exec")
		pass
	else:
		pass
	pass # Replace with function body.


func _on_UI_NoPlease():
	
	pass # Replace with function body.

func _on_ScronchKey_body_entered(body):
	print(body.name+" Out of Bound!")
	body.free()
	pass # Replace with function body.


func _on_InitScronch_body_entered(body):
#	if $"GameField/GamePlay/Scroncher/InitScronch".isStarted:
#		print("Init Scronched the " + body.name)
#		body.free()
#		pass
#	else:
#		pass
	pass # Replace with function body.


func _on_InitScronch_body_shape_entered(body_id, body, body_shape, area_shape):
#	if $"GameField/GamePlay/Scroncher/InitScronch".isStarted:
#		print("Init Scronched the " + body.name)
#		body.free()
#		pass
#	else:
#		pass
	pass # Replace with function body.


func _on_DontShoot_input_event(viewport, event, shape_idx):
#	if event is InputEventMouseButton:
#		print("Bakgron hit")
#		if event.pressed:
#			print("Hit Bekgron")
#			if isPlayingGameNow:
#				Ouch()
#				pass
#			pass
#		print("Hit Bekgron")
#		if isPlayingGameNow:
#			Ouch()
#			pass
#		pass
	pass # Replace with function body.


func _on_DontShoot_PlayerHitMe():
	if isPlayingGameNow:
#		Ouch()
#		print("Ouch Bekgron")
		pass
	pass # Replace with function body.


func _on_DontShootArea_gui_input(event):
#	if event is InputEventMouseButton:
#		if event.pressed:
#			if isPlayingGameNow:
#				Ouch()
#				print("Ouch Bekgron")
#				pass
#			pass
#		pass
	
	pass # Replace with function body.


func _on_UI_NextWeponPlease():
	
	pass # Replace with function body.


func _on_UI_PausePlease():
	
	pass # Replace with function body.


func _on_UI_PrevWeponPlease():
	
	pass # Replace with function body.


func _on_UI_ReloadPlease():
	
	pass # Replace with function body.
