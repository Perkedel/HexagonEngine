extends Node

export (bool) var isPlayingGameNow
export (bool) var isGamePaused
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Singleton. Ahlinya Intinya inti, Core of the core. 

# Called when the node enters the scene tree for the first time.
func _ready():
	AutoSpeaker.stream = preload("res://Audio/EfekSuara/425728__moogy73__click01.wav")
	AutoSpeaker.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Nonaktifkan_Sistem():
	#AutoSpeaker.stream = preload("res://GameDVDCardtridge/GeogonPolymetryHaventDoneYetSalvage/Audio/Explosion bin cropped.wav")
	#AutoSpeaker.play()
	Kixlonzing.SaveKixlonz()
	Settingers.SettingSave()
	print("Quit Game!")
	#get_tree().queue_delete(get_tree())
	#get_tree().queue_free()
	#yield(AutoSpeaker, "finished")
	get_tree().quit()
	pass

func _exit_tree():
	pass

func PauseGameNow():
	get_tree().paused = true
	isGamePaused = true
	pass

func ResumeGameNow():
	get_tree().paused = false
	isGamePaused = false
	pass
