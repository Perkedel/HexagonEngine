@tool	#The script runs whenever the file is saved or the project is opened because of the tool instruction.
extends EditorPlugin
#Currently designed as a "CustomType" node. Per Godot tutorials (4.x) this means it has fewer features than one using the "Script Class" system. see: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#doc-gdscript-basics-class-name

const RNG_Plugin_Panel = preload("res://addons/betterrandnumgen/v_box_container.tscn")
const THE_ICON = preload("res://addons/betterrandnumgen/icon.png") #icon

var trng_plugin_instance

func _enter_tree():		#functions starting with an underscore are default functions that we are over-riding by creating them here.
	# Initialization of the plugin goes here.
	trng_plugin_instance = RNG_Plugin_Panel.instantiate()
	
	# Add the main panel to the editor's main viewport
	get_editor_interface().get_editor_main_screen().add_child(trng_plugin_instance)
	
	#Hide the main panel. Important? Not yet sure. Per documentation, by default new node items added to a scene are NOT VISIBLE.
	_make_visible(false) #testing shows that removing this does not affect performance or function, however it will then be automatically shown on screen.

func _exit_tree():# Clean-up of the plugin goes here.
	if trng_plugin_instance:
		trng_plugin_instance.queue_free()

func _has_main_screen():   #forces check to ensure this pluging only runs on main screen. If not present then plugin would run at all times in the background.
	return true 
	
func _make_visible(visible):   #If the plugin exists, change visibility flag to true, making it visible
	if trng_plugin_instance:
		trng_plugin_instance.visible = visible


func _get_plugin_name():   #set the plugin name
	return "Better Rand Number Gen 1.3.2"
	
func _get_plugin_icon():   #set the plugin icon
	return THE_ICON #get_editor_interface().get_base_control().get_theme_icon("Node","EditorIcons")

#func _handles(node): 	#Another function you can add is the handles() function, which allows you to handle a node type, automatically focusing the main screen when the type is selected. 
	#This is similar to how clicking on a 3D node will automatically switch to the 3D viewport.
#	return

#func _enable_plugin():		#start the plugin. Not typically needed.
#	return true

#func _ready():	#what to do when this script reports it is ready (Note: it can report ready for several varying reasons
	#1 - When the node is added to the tree. (Export setter functions are not called because the default values are used.)
	#2 - Not called when the script is saved, but any 'export'-ed functions may be called several times, and the child nodes may not be ready until the last of the calls completes.
	#3 - If any 'export'-ed functions are called, the export setter function is called.
	#4 - The export setter function is called if the value is not the default value, then the _ready function is called.
	

