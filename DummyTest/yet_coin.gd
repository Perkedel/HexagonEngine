extends Area3D
class_name YetCoin

@export_enum('Pon','Health','PowerUp') var collectType:String = 'Pon'
@export var amountF:float = 1
@export var argument:String = ''

@export_group('Sound')
@export var collectSound = preload("res://modules/Reusables/AudioRandomizer/collect_SoundRandom.tres")

@export_group('Post Collission')
@export_enum('Hide','Delete','Stay','Freeze') var whatToDoAfter:String = 'Hide'

@export_group('Specifity')
@export var allowAllTypes:bool = false
@export var expectedGroup:String = 'player'

@onready var forms:=$Shapes
@onready var formsList:=forms.get_children()
@onready var centerSpeaker = $CenterSpeaker

var isCollected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func resetNow():
	isCollected = false
	showMeshForms(0)
	show()
	set_process(true)
	pass

func _centerSound(what:AudioStream):
	centerSpeaker.stream = what
	centerSpeaker.play()
	pass

func emitParticleForm(whichIs:String='collect'):
	for i in formsList:
		if i.visible:
			if i.has_method('emitParticle'):
				i.call('emitParticle',whichIs)
	pass

func hideForms():
	for i in formsList:
		i.hide()
	pass

func hideAllMeshForms():
	for i in formsList:
		if i.has_method('hideMesh'):
			i.call('hideMesh')
	pass

func showMeshForms(whichIs:int = 0):
	if formsList[whichIs].has_method('showMesh'):
		formsList[whichIs].call('showMesh')
	pass

func afterCollision(doThe:String):
	isCollected = true
	emitParticleForm()
	_centerSound(collectSound)
	match(doThe):
		'Hide':
			set_process(false)
#			hide()
#			hideForms()
			hideAllMeshForms()
			pass
		'Delete':
			# you must await audio finish first!
			queue_free()
		'Stay':
			# do nothing
			pass
		'Freeze':
			set_process(false)
		_:
			pass
	pass

func checkAndCollect(body:Node3D):
	if visible and not isCollected:
		if body.is_in_group(expectedGroup) or allowAllTypes:
			if body.has_method('collectItem'):
				body.call('collectItem',self,collectType,amountF,argument)
	#			afterCollision(whatToDoAfter)
				pass
			pass
		pass
	pass

func acknowledge(player:Node3D):
	# the player will acknowledge after processed the item.
	afterCollision(whatToDoAfter)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	checkAndCollect(body)
	pass # Replace with function body.
