extends Position2D

export (bool) var Activated = false
export (PackedScene) var SpawnThisTscene
export (bool) var Randomizing = true
export (float) var SetSpawnIn = 5
export (float) var SpawnMin = 1
export (float) var SpawnMax = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func SpawnFollowingObject():
	var ObjectInstancer = SpawnThisTscene.instance()
	ObjectInstancer.position = position
	$"..".add_child(ObjectInstancer)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnInATimer.wait_time = SetSpawnIn
	if Activated:
		if $SpawnInATimer.is_stopped():
			$SpawnInATimer.start()
			pass
		pass
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnInATimer_timeout():
	SpawnFollowingObject()
	if Randomizing:
		$SpawnInATimer.wait_time = rand_range(SpawnMax,SpawnMax)
		pass
	pass # Replace with function body.
