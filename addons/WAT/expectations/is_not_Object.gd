func _init(value, context: String) -> void:
	var passed: String = "%s is not builtin: Object" % value
	var failed: String = "%s is builtin: Object" % value
	self.context = context
	self.success = not value is Object
	self.expected = passed
	self.result = passed if self.success else failed