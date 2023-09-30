extends Node3D

@onready var explodos = $Explodos
@onready var animP = $AnimationPlayer
@onready var mesh = $KayKitCoinMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playAnimation(named: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false
):
	animP.stop(false)
	animP.play(named,custom_blend,custom_speed,from_end)
	pass

func hideMesh():
	mesh.hide()
	pass

func emitParticle(whichType:String='collect'):
	match(whichType):
		'death':
#			print('explodesz')
#			explodos.restart()
			pass
		'cure':
			pass
		'collect':
			explodos.restart()
			pass
		_:
			pass
	pass
