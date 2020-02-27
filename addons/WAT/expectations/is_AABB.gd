extends "base.gd"

func _init(value, context: String) -> void:
	var passed: String = "%s is builtin: AABB" % value
	var failed: String = "%s is not builtin: AABB" % value
	self.context = context
	self.success = value is AABB
	self.expected = passed
	self.result = passed if self.success else failed