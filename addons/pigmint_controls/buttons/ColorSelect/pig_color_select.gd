#==== :@) ==== 8@) ==== ´ö` ==== :@) ==== 8@) ==== ´ö` ==== :@) ==== 8@) ==== ´ö` ====
# pig_color_select.gd
#-------------------------------------------------------------------------------------
# Description: 'PigColorSelect' control class (subclass of 'PigletColorSelect')
# Project:     'Pigmint Controls': a custom controls Plugin for Godot 3
#              https://github.com/Echopraxium/PigmintControls
# Author:      Echopraxium 2020
# Version:     0.0.31 (2020/01/24) AAAA/MM/DD
#-------------------------------------------------------------------------------------
# Documentation
# * https://docs.godotengine.org/en/3.1/tutorials/plugins/editor/making_plugins.html
# * http://www.alexhoratio.co.uk/2018/08/godot-complete-guide-to-control-nodes.html
#==== :@) ==== 8@) ==== ´ö` ==== :@) ==== 8@) ==== ´ö` ==== :@) ==== 8@) ==== ´ö` ====
tool
# 'PigColorSelect' is a subclass of 'PigletColorSelect'
extends "res://addons/pigmint_controls/buttons/ColorSelect/piglet_color_select.gd"

# Note: don't use 'class_name' because it seems not well supported in this version of Godot: 
# Test: When using 'class_name' and adding a child by searching for 'Pig', I see a weird item: 
#       'PigColorSelect (pig_color_select.gd)' without the custom 16x16 icon that I provide
#class_name PigColorSelect


""" 32x32 PigColorSelect icon
+--------------+................
|$$$$$$$$$$$$$$|................ 
|$$$$$$$$$$$$$$|................
|$$$$$$$$$$$$$$|...X............
|$$$$$$$$$$$$$$|..XX............
|$$$$$$$$$$$$$$|.XXXXXXX........
|$$$$$$$$$$$$$$|..XX....X.......
|$$$$$$$$$$$$$$|...X.....x......
|$$$$$$$$$$$$$$|..........X.....
|$$$$$$$$$$$$$$|..........X..... 
|$$$$$$$$$$$$$$|..........X.....
|$$$$$$$$$$$$$$|..........X.....
|$$$$$$$$$$$$$$|........XXXXX...
|$$$$$$$$$$$$$$|.........XXX....
|$$$$$$$$$$$$$$|..........X.....
+--------------+................ 
................+--------------+ 
................|°°°°°°°°°°°°°°|
................|°°°°°°°°°°°°°°| 
+-------+.......|°°°°°°°°°°°°°°|
|*******|.......|°°°°°°°°°°°°°°|
|*******|.......|°°°°°°°°°°°°°°| 
|*******|.......|°°°°°°°°°°°°°°|
|*******+---+...|°°°°°°°°°°°°°°|
|*******|:::|...|°°°°°°°°°°°°°°| 
|*******|:::|...|°°°°°°°°°°°°°°|
|*******|:::|...|°°°°°°°°°°°°°°|
+---+---+:::|...|°°°°°°°°°°°°°°|
....|:::::::|...|°°°°°°°°°°°°°°|
....|:::::::|...|°°°°°°°°°°°°°°|
....|:::::::|...|°°°°°°°°°°°°°°|
....+-------+...+--------------+
"""

#----------------------------------------------------------------------------------------
#----- Redefine virtual functions here for 'PigColorSelect' part's position and size ----
#----------------------------------------------------------------------------------------
func _getIconPath():
    return "res://addons/pigmint_controls/buttons/ColorSelect/pig_color_select.png"

# allows to choose an alternative ColorPicker dialog 
func _getColorPickerDialog():
    return _g_color_chooser_dialog

# allows to get picked color when an alternative ColorPicker dialog is used
func _getPickedColor():
    return _g_color_chooser_dialog.get_pick_color()
	
func _getColorPartSize():
    return 14

func _getResetPartSize():
    return 14
	
func _getSwitchPartPosition():
    return Vector2(17,3)
	
func _getBackgroundColorPosition():
    return Vector2(17,17)
	
func _getResetPartPosition():
    return Vector2(1,20)
	
func _getSwitchPartSize():
    return 12
#----- Redefine virtual functions here for 'PigColorSelect' part's position and size


#------------------------------------------------------------------------
#----------------------       _enter_tree()        ----------------------
#------------------------------------------------------------------------
func _enter_tree():
    g_icon_path = _getIconPath()
	
    FG_BG_PART_SIZE        = _getColorPartSize()
    BG_PART_POSITION       = _getBackgroundColorPosition()
    SWITCH_PART_POSITION   = _getSwitchPartPosition()
    SWITCH_PART_SIZE       = _getSwitchPartSize()
    RESET_PART_POSITION    = _getResetPartPosition()
    RESET_PART_SIZE        = _getResetPartSize()

    BUTTON_SIZE = Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE)
    _set_icon()
#---------- _enter_tree()