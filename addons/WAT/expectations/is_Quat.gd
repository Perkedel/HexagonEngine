extends "base.gd"

func _init(value, context: String) -> void:
	var passed: String = "%s is builtin: Quat" % value
	var failed: String = "%s is not builtin: Quat" % value
	self.context = context
	self.success = value is Quat
	self.expected = passed
	self.result = passed if self.success else failed