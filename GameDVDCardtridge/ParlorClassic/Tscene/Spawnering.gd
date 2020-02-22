extends Position2D

export (bool) var Activated = false
export (PackedScene) var SpawnThisTscene
var TargetNode 
export (PoolStringArray) var SpawnSceneStrings
export (bool) var Randomizing = true
export (float) var SetSpawnIn = 5
export (float) var SpawnMin = 1
export (float) var SpawnMax = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func SpawnFollowingObject():
	print("SpawnStuff")
	var ObjectInstancer = SpawnThisTscene.instance()
	ObjectInstancer.position = position
	if TargetNode:
		TargetNode.add_child(ObjectInstancer)
		pass
	else:
		$"..".add_child(ObjectInstancer)
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if Randomizing:
		$SpawnInATimer.wait_time = SetSpawnIn
	else:
		$SpawnInATimer.wait_time = rand_range(SpawnMin, SpawnMax)
		pass
#	$SpawnInATimer.wait_time = SetSpawnIn
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Activated:
		if $SpawnInATimer.is_stopped():
			$SpawnInATimer.start()
			print("Spawner Started")
			pass
		pass
	else:
		if !$SpawnInATimer.is_stopped():
			$SpawnInATimer.stop()
			print("Spawner Stopped")
			pass
		pass
	pass


func _on_SpawnInATimer_timeout():
	SpawnFollowingObject()
	if Randomizing:
		#print("Randomize Timer!")
		$SpawnInATimer.stop()
		$SpawnInATimer.wait_time = rand_range(SpawnMin,SpawnMax)
		print("Randomize Timer " + String($SpawnInATimer.wait_time))
		if Activated:
			$SpawnInATimer.start()
			pass
		pass
	pass # Replace with function body.
