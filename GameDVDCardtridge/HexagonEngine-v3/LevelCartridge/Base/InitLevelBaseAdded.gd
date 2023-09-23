extends HexagonLevel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Singletoner.replacePosess($YetStupid,0)
#	$YetStupid.setOwnActivate(true)
#	$CamRig.assignCamera($YetStupid)
	$YetStupid.assignCamera($CamRig)
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
			$YetStupid.setOwnActivate(true)
			$CamRig.setOwnActivate(true)
			pass
		_:
			$YetStupid.setOwnActivate(false)
			$CamRig.setOwnActivate(false)
			pass
	return super.recheckMenu()
