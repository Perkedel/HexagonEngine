tool
extends EditorPlugin


func _enter_tree():
    var gui = get_editor_interface().get_base_control()
    var icon = gui.get_icon("Node", "EditorIcons")
    add_custom_type("TaskDispatcher", "Node", preload("task_dispatcher.gd"), icon)

func _exit_tree():
    remove_custom_type("TaskDispatcher")
