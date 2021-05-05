extends Spatial

# # Mitch Makes things interact https://youtu.be/C_-faOyIuTQ
# Miziziziz 3D Platformer tutorial https://youtu.be/1I3z5ZpBOmc

var LevelComplete = false
# GradeAUnderA tada https://youtu.be/skMloYSZiRw
export var LevelCompleteSoundStream :AudioStream = load( "res://GameDVDCardtridge/GeogonPolymetryProofConceptSalvage/Sounds/GradeAUnderA Tada.wav")
onready var anPlayer = $ProsotipePlatformerGuy
onready var checkpointPos = anPlayer.transform
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_JatuhAAA_PlayerDidFell():
	anPlayer.transform = checkpointPos
	pass # Replace with function body.


func _on_LifePartnerWin_InteractGoaled():
	if LevelComplete:
		return
	
	$YayComplete.PopThisDialogWith("")
	$LocalAudio.stream = LevelCompleteSoundStream
	$LocalAudio.play()
	pass # Replace with function body.
