extends BaseGameObject
class_name GameObject

var components = Dictionary()
var world : BaseGameWorld setget set_world, get_world
#warning-ignore:unused_class_variable
var node : NodePath


func _get_property_list() -> Array:
	var list = [
		{
			"name" : "id",
			"type" : TYPE_STRING,
			"usage" : PROPERTY_USAGE_STORAGE
		},
		{
			"name" : "node",
			"type" : TYPE_NODE_PATH,
			"usage" : PROPERTY_USAGE_STORAGE
		},
	]
	for component in components.keys():
		list.append({
			"name" : component,
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "Component",
			"usage" : PROPERTY_USAGE_STORAGE
		})
	return list

func set_world(value : BaseGameWorld):
	if !(value is BaseGameWorld):
		return
	if world != null:
		if !world._remove_object(self):
			var warn_string = "Tried to remove {id} from {name}, but it was not inside.".format({"id" : self.id, "name" : world.name})
			push_warning(warn_string)
	world = value
	world._add_object(self)
	
func get_world() -> BaseGameWorld:
	return world

func has_component(name : String) -> bool:
	return components.has(name)

func get_component(name : String) -> Component:
	if !has_component(name):
		if self.world == null or !world.components.has(name) or !_set(name, world.components[name].new()):
			return null
	return components[name]
	
func _get(property : String):
	return get_component(property)	

func _set(property : String, value : Object) -> bool:
	if !(value is Component):
		return false
	var component = value as Component
	component.game_object = self
	components[property] = component
	return true
