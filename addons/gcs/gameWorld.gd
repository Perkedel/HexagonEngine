extends BaseGameWorld
class_name GameWorld

func _process(delta : float):
	for system in systems:
		system._process(delta)

func _physics_process(delta : float):
	for system in systems:
		system._physics_process(delta)
	yield(root_node.get_tree(), "idle_frame")
	for system in systems:
		system._after_physics_process(delta)

func get_objects_with_component(component) -> Array:
	var found_objects = Array()
	for game_object in game_objects.values():
		if game_object is GameObject:
			if game_object.has_component(component):
				found_objects.append(game_object)
	return found_objects
	
func save(path : String):
	ResourceSaver.save(path, self)
	
func load(path : String) -> bool:
	if !ResourceLoader.exists(path, "GameWorld"):
		return false
	var loaded : GameWorld = ResourceLoader.load(path, "GameWorld")
	for game_object in loaded.game_objects.values():
		self._add_object(game_object)
	return true