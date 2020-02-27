extends "base.gd"

func _init(value, context: String) -> void:
	var passed: String = "%s is builtin: Color" % value
	var failed: String = "%s is not builtin: Color" % value
	self.context = context
	self.success = value is Color
	self.expected = passed
	self.result = passed if self.success else failed
