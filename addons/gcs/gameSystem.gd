extends BaseGameSystem
class_name GameSystem

var world : BaseGameWorld

func _init(world : BaseGameWorld):
	self.world = world
	world._add_system(self)
