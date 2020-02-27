extends Resource
class_name BaseGameWorld

const UUID = preload("res://addons/uuid/uuid.gd")

#warning-ignore:unused_class_variable
var components = Dictionary()
var systems = Array()
var game_objects = Dictionary()
#warning-ignore:unused_class_variable
var root_node : Node
	
func _get_property_list() -> Array:
	var list = []
	for id in game_objects.keys():
		list.append({
			"name" : id,
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "GameObject",
			"usage" : PROPERTY_USAGE_STORAGE
		})
	return list

func _add_object(game_object : BaseGameObject):
	if game_objects.values().has(game_object):
		return
	while game_object.id == null or game_object.id == "" or (game_objects.has(game_object.id) and game_objects[game_object.id] != game_object):
		game_object.id = UUID.v4()
	game_objects[game_object.id] = game_object
	game_object.world = self

func _remove_object(game_object : BaseGameObject) -> bool:
	return _remove_object_by_id(game_object.id)

func _remove_object_by_id(id : String) -> bool:
	return game_objects.erase(id)

func _add_system(game_system : BaseGameSystem):
	systems.append(game_system)

func _get(id : String) -> Component:
	if game_objects.has(id):
		return game_objects[id]
	return null

func _set(id : String, value : Object) -> bool:
	if !(value is BaseGameObject):
		return false
	var game_object = value as BaseGameObject
	game_object.id = id
	_add_object(game_object)
	return true
