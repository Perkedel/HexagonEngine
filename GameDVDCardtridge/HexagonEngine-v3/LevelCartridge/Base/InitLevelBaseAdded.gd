extends HexagonLevel

@onready var hideableTester:Node3D = $Hideable_test
@onready var selfieCam:Camera3D = $selfie_camera
@onready var gateADoors:Array[Node3D] = [
	$YetDoor,
	$YetDoor2,
	$YetDoor3,
	$YetDoor4,
]
var gateA:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Singletoner.monitorThisCharacter($YetStupid)
#	Singletoner.replacePosess($YetStupid,0)
#	$YetStupid.setOwnActivate(true)
#	$CamRig.assignCamera($YetStupid)
#	$YetStupid.assignCamera($CamRig)
#	$CamRig.setOwnActivate(true)
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	pass

func recheckMenu() -> String:
	match(Singletoner.currentMenu):
		'Gameplay':
#			print('PLAAAAAAAAAAAAAAAAAAAY')
#			$YetStupid.setOwnActivate(true)
#			$CamRig.setOwnActivate(true)
#			Singletoner.monitorThisCharacter($YetStupid)
			pass
		_:
#			$YetStupid.setOwnActivate(false)
#			$CamRig.setOwnActivate(false)
			pass
	return super.recheckMenu()

func _notification(what: int) -> void:
	match(what):
		_:
			pass
	super._notification(what)
	pass


func _on_interactible_yet_interacted(with):
	hideableTester.toggleVisible()
	pass # Replace with function body.


func _on_seflie_button_interacted(with):
#	selfieCam.current = not selfieCam.current
	pass # Replace with function body.


func _on_door_button_interacted(with):
	for i in gateADoors:
		if gateA:
			# was open, let's close
			if i.has_method('close'):
				i.call('close')
			pass
		else:
			# was close, let's open
			if i.has_method('open'):
				i.call('open')
			pass
		pass
	gateA = not gateA
	pass # Replace with function body.
