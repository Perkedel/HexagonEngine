extends Node

var toast;

func _ready():
	call_deferred("showToast", "normal")

func showToast(type: String):
	match type:
		"normal":
			toast = Toast.new("This is the default toast", Toast.LENGTH_SHORT)
			get_node("/root").add_child(toast)
			toast.connect("done", Callable(self, "showToast").bind("full"))
			toast.show()
		"full":
			toast = Toast.new("This is a full toast", Toast.LENGTH_SHORT, preload("res://examples/Toast/full_bottom_toast_style.tres"))
			get_node("/root").add_child(toast)
			toast.connect("done", Callable(self, "showToast").bind("normal_top"))
			toast.show()
		"normal_top":
			toast = Toast.new("This is a normal toast positioned at the top", Toast.LENGTH_SHORT, preload("res://examples/Toast/float_top_toast_style.tres"))
			get_node("/root").add_child(toast)
			toast.connect("done", Callable(self, "showToast").bind("full_top"))
			toast.show()
		"full_top":
			toast = Toast.new("This is a full toast positioned at the top", Toast.LENGTH_SHORT, preload("res://examples/Toast/full_top_toast_style.tres"))
			get_node("/root").add_child(toast)
			toast.show()
