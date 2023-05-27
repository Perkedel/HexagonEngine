extends Node2D

@export (PackedScene) var BulletSceneFile = load("res://GameDVDCardtridge/ParlorClassic/Tscene/Peluru.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func SpawnBullet(positione:Vector2):
	var InstanceBullet = BulletSceneFile.instantiate()
	InstanceBullet.position = positione
	#$GameField/GamePlay/Bullets.add_child(InstanceBullet)
	#$GameField/GamePlay/Targets.add_child(InstanceBullet)
	add_child(InstanceBullet)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			SpawnBullet(event.position)
			pass
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DontShoot_PlayerHitMe():
	pass # Replace with function body.
