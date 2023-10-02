extends Node3D

@export var stopFirstBeforePlayOther:bool = false
@export var keepStateAsItStopped:bool = false
@onready var animP:AnimationPlayer = $AnimationPlayer
@onready var animT:AnimationTree = $AnimationTree
@export var mesh:MeshInstance3D
@export var explodos:GPUParticles3D
@export var sparkle:GPUParticles3D
@export var shine:GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playAnimation(named: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false
):
	if stopFirstBeforePlayOther:
		animP.stop(keepStateAsItStopped)
	animP.play(named,custom_blend,custom_speed,from_end)
	pass

func playAnimationBackwards(named:StringName = "", custom_blend:float = -1):
	if stopFirstBeforePlayOther:
		animP.stop(keepStateAsItStopped)
	animP.play_backwards(named, custom_blend)
	pass

func showMesh():
	if mesh:
		mesh.show()
	pass

func hideMesh():
	if mesh:
		mesh.hide()
	pass

func emitParticle(whichType:String='collect'):
	match(whichType):
		'death':
#			print('explodesz')
			if explodos:
				explodos.restart()
			pass
		'cure':
			pass
		'collect':
			if sparkle:
				sparkle.restart()
			pass
		_:
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
