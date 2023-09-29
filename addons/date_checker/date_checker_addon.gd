@tool
extends EditorPlugin


const DATECHECKERNAME: String = "DateChecker"
const DATECHECKER_PATH: String = "res://addons/date_checker/date_checker.gd"


func _enter_tree():
	add_autoload_singleton(DATECHECKERNAME, DATECHECKER_PATH)


func _exit_tree():
	remove_autoload_singleton(DATECHECKERNAME)

