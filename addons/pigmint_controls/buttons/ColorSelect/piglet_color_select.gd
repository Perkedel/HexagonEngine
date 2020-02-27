#==== :@) ==== 8@) ==== ´ö` ==== :@) ==== 8@) ==== ´ö` ==== :@) ==== 8@) ==== ´ö` ====
# piglet_color_select.gd
#-------------------------------------------------------------------------------------
# Description: 'PigletColorSelect' control class
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
extends TextureButton

# Note: don't use 'class_name' because it seems not well supported in this version of Godot: 
# Test: When using 'class_name' and adding a child by searching for 'Pig', I see a weird item:
#       'PigletColorSelect (piglet_color_select.gd)' without the custom 16x16 icon that I provide
#class_name PigletColorSelect


#---------------------- Signals -----------------------
signal foreground_color_changed(fg_color)
signal background_color_changed(bg_color)
signal colors_switch(color_select_control)
signal colors_reset(color_select_control)
#------------------------------------------------------


#------------------ PredefinedColors ------------------
const PredefinedColors =  {
	BLACK      = Color(0,0,0),
	WHITE      = Color(1,1,1),
	RED        = Color(1,0,0),
	GREEN      = Color(0,1,0),
	BLUE       = Color(0,0,1),
	YELLOW     = Color(1,1,0),
	MAGENTA    = Color(1,0,1),
	CYAN       = Color(0,1,1),
	GREY       = Color(.5,.5,.5),
	LIGHT_GREY = Color(.7,.7,.7),
	DARK_GREY  = Color(.3,.3,.3)
} 
#-----------------------------------------------------


#---------- Button parts: position and size ----------
var   FG_BG_PART_SIZE        = _getColorPartSize()
var   BG_PART_POSITION       = _getBackgroundColorPosition()
var   SWITCH_PART_POSITION   = _getSwitchPartPosition()
var   SWITCH_PART_SIZE       = _getSwitchPartSize()
var   RESET_PART_POSITION    = _getResetPartPosition()
var   RESET_PART_SIZE        = _getResetPartSize()
#-----------------------------------------------------


#------------------ Button parts ---------------------
enum ButtonPart { 
    FOREGROUND, BACKGROUND, SWITCH, RESET, NONE=-1
}
#-----------------------------------------------------

var g_icon_path              = null

var g_clicked_part           = ButtonPart.NONE

export (Color) var ForeColor = PredefinedColors.BLACK
export (Color) var BackColor = PredefinedColors.WHITE

var g_foreground_reset_color = PredefinedColors.BLACK
var g_background_reset_color = PredefinedColors.WHITE

var _g_initialized            = false
var _g_color_chooser_dialog:ColorPicker = null

var _g_count_frame = 0
var _g_button_must_be_redrawn = false

var _g_normal_texture = null

var ORIGIN      = Vector2(0,0)
var BUTTON_SIZE = Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE)


""" 24x24 PigletColorSelect icon
+---------+.............
|$$$$$$$$$|.............
|$$$$$$$$$|...X......... 
|$$$$$$$$$|..XX.........
|$$$$$$$$$|.XXXXXX......
|$$$$$$$$$|..XX...X.....
|$$$$$$$$$|...X....X....
|$$$$$$$$$|........X....
|$$$$$$$$$|........X....
|$$$$$$$$$|......XXXXX.. 
+---------+.......XXX... 
...................X.... 
........................ 
.............+---------+ 
+-----+......|°°°°°°°°°| 
|*****|......|°°°°°°°°°| 
|*****|......|°°°°°°°°°| 
|*****+--+...|°°°°°°°°°|
|*****|::|...|°°°°°°°°°| 
|*****|::|...|°°°°°°°°°| 
+--+--+::|...|°°°°°°°°°|
...|:::::|...|°°°°°°°°°| 
...|:::::|...|°°°°°°°°°| 
...+-----+...+---------+
"""


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
    connect("pressed", self, "_clicked")
    _g_color_chooser_dialog = ColorPicker.new()
    _g_color_chooser_dialog.connect("gui_input", self, "_on_Color_select_dialog_gui_input")
#---------- _enter_tree()


#------------------------------------------------------------------------
#-----------------  _on_Color_select_dialog_gui_input() -----------------
#------------------------------------------------------------------------
func _on_Color_select_dialog_gui_input(event):
    #_g_button_must_be_redrawn = false
    if (event is InputEventMouseButton):
        #print("_on_Color_select_dialog_gui_input  InputEventMouseButton")
        var picked_color = _getPickedColor()
        _g_color_chooser_dialog.hide()
		
        if   (g_clicked_part == ButtonPart.FOREGROUND):
            ForeColor = picked_color
            emit_signal("foreground_color_changed", ForeColor)
            #_g_button_must_be_redrawn = true
            update()
        elif (g_clicked_part == ButtonPart.BACKGROUND):
            BackColor = picked_color
            emit_signal("background_color_changed", BackColor)
            #_g_button_must_be_redrawn = true
            update()
#---------- _on_Color_select_dialog_gui_input()


#---------- ForegroundColor getter/setter ----------
func set_foreground_color(fg_color):
    ForeColor = fg_color
	
func get_foreground_color():
	return ForeColor
#---------------------------------------------------


#---------- BackgroundColor getter/setter ----------
func set_background_color(bg_color):
    BackColor = bg_color
	
func get_background_color():
    return BackColor
#---------------------------------------------------


#-------------------------------------------------------------------------------------------
#----- These virtual functions allow to redefine part's position and size in subclasses ----
#-------------------------------------------------------------------------------------------
func _getIconPath():
    return "res://addons/pigmint_controls/buttons/ColorSelect/piglet_color_select.png"

# allows to choose an alternative ColorPicker dialog 
func _getColorPickerDialog():
    return _g_color_chooser_dialog
	
# allows to get picked color when an alternative ColorPicker dialog is used
func _getPickedColor():
    return _g_color_chooser_dialog.get_pick_color()
	
func _getColorPartSize():
    return 9

func _getResetPartSize():
    return 10
	
func _getSwitchPartPosition():
    return Vector2(12,2)
	
func _getBackgroundColorPosition():
    return Vector2(14,14)
	
func _getResetPartPosition():
    return Vector2(1,15)
	
func _getSwitchPartSize():
    return 10
#----- These virtual functions allow to redefine part's position and size in subclasses
	

#----------------------------------------------------
#------------   _definePresetColors()    ------------
#----------------------------------------------------
func _definePresetColors():
     _g_color_chooser_dialog.add_preset(PredefinedColors.WHITE)
     _g_color_chooser_dialog.add_preset(PredefinedColors.RED)
     _g_color_chooser_dialog.add_preset(PredefinedColors.YELLOW)
     _g_color_chooser_dialog.add_preset(PredefinedColors.CYAN)
     _g_color_chooser_dialog.add_preset(PredefinedColors.BLUE)
     _g_color_chooser_dialog.add_preset(PredefinedColors.MAGENTA)
     _g_color_chooser_dialog.add_preset(PredefinedColors.WHITE)
     _g_color_chooser_dialog.add_preset(PredefinedColors.LIGHT_GREY)
     _g_color_chooser_dialog.add_preset(PredefinedColors.DARK_GREY)
     _g_color_chooser_dialog.add_preset(PredefinedColors.BLACK)
#----- _definePresetColors()


#----------------------------------------------------
#---------------      _clicked()      ---------------
#----------------------------------------------------
func _clicked():
    #print("ColorSwitchButton clicked me!")
    var node_rect = get_global_rect()
	
    #print("node x: " + str(node_rect.position.x) + " y:" + str(node_rect.position.y))
    var mouseXY = get_viewport().get_mouse_position()
    #print("mouseXY x: " + str(mouseXY.x) + " y:" + str(mouseXY.y))
	
    var request_color_from_user = false
	
    _g_button_must_be_redrawn = false
	
    var clicked_part = _detect_clicked_part(node_rect, mouseXY)
    if (clicked_part != ButtonPart.NONE):
        if (clicked_part == ButtonPart.FOREGROUND):
            #print("FOREGROUND_PART clicked")
            request_color_from_user = true

        elif (clicked_part == ButtonPart.BACKGROUND):
            #print("BACKGROUND_PART clicked")
            request_color_from_user = true

        elif (clicked_part == ButtonPart.SWITCH):
            #print("SWITCH_PART clicked")
            var save_fg_color   = ForeColor
            ForeColor           = BackColor 
            BackColor           = save_fg_color
            g_clicked_part      = clicked_part
            emit_signal("colors_switch", self)
            _g_button_must_be_redrawn = true
            update()
            return

        elif (clicked_part == ButtonPart.RESET):
            #print("RESET_PART clicked")
            ForeColor      = g_foreground_reset_color 
            BackColor      = g_background_reset_color
            g_clicked_part = clicked_part
            emit_signal("colors_reset", self)
            #_g_button_must_be_redrawn = true
            update()
            return

        #---------- If user clicked either "FOREGROUND" or "BACKGROUND" part ----------
        if (request_color_from_user == true):
            #print("request_color_from_user")
            if (not _g_initialized):
                get_owner().add_child(_g_color_chooser_dialog)
                _definePresetColors()
                _g_initialized = true
            var color_chooser_x = node_rect.position.x
            var color_chooser_y = node_rect.position.y + node_rect.size.y
            _getColorPickerDialog().rect_position = Vector2(color_chooser_x, color_chooser_y)
            g_clicked_part = clicked_part
            _getColorPickerDialog().show()
#----- _clicked()


#----------------------------------------------------
#---------------       _draw()        ---------------
#----------------------------------------------------
# Redraw button to color the parts consistently 
# with foreground and background colors
func _draw():
    #if (not _g_button_must_be_redrawn):
    #    return
		
    #print("_draw " + str(_g_count_frame))
    #_g_count_frame = _g_count_frame + 1
	
    # Note: doesnt draw at the right spot with either:
    #       get_rect(), get_global_rect(), get_transform(), get_global_transform()
    var rect = get_canvas_transform()
	
    #---------- Paint "FOREGROUND" part ----------
    var x = rect.origin.x + 1
    var y = rect.origin.y + 1
    var foreground_rect = Rect2(Vector2(x, y), BUTTON_SIZE)
    draw_rect(foreground_rect, ForeColor)
    #---------------------------------------------

    #---------- Paint "BACKGROUND" part ----------
    x = rect.origin.x + BG_PART_POSITION.x
    y = rect.origin.y + BG_PART_POSITION.y
    var background_rect = Rect2(Vector2(x, y), BUTTON_SIZE)
    draw_rect(background_rect, BackColor)
    #---------------------------------------------
	
    #_g_button_must_be_redrawn = false

    #---------- Paint "RESET FOREGROUND" part ----------
    #x = rect.origin.x + BG_PART_START
    #y = rect.origin.y + BG_PART_START
    #var reset_foreground_rect = Rect2(Vector2(x, y), Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE))
    #draw_rect(reset_foreground_rect, _g_foreground_color)
    #---------------------------------------------


    #---------- Paint "RESET BACKGROUND" part ----------
    #x = rect.origin.x + BG_PART_START
    #y = rect.origin.y + BG_PART_START
    #var reset_background_rect = Rect2(Vector2(x, y), Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE))
    #draw_rect(reset_background_rect, _g_foreground_color)
    #---------------------------------------------
#----- _draw()
    

#----------------------------------------------------
#-----------    _detect_clicked_part()    -----------
#----------------------------------------------------
func _detect_clicked_part(rect, mouseXY):
    #print("rect x: " + str(rect.position.x) + " y:" + str(rect.position.y))	
    var rect_x = rect.position.x # get_transform().get_origin().x
    var rect_y = rect.position.y # get_transform().get_origin().y
    var x      = mouseXY.x - rect_x
    var y      = mouseXY.y - rect_y


	#---------- Check if mouse is inside "FOREGROUND PART" ---------
    var start_part = ORIGIN
    var end_part   = BUTTON_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return ButtonPart.FOREGROUND
    #----------------------------------------------------------------


	#---------- Check if mouse is inside "BACKGROUND PART" ----------
    start_part.x = BG_PART_POSITION.x
    start_part.y = BG_PART_POSITION.y
    end_part.x   = start_part.x + FG_BG_PART_SIZE
    end_part.y   = start_part.y + FG_BG_PART_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return ButtonPart.BACKGROUND
    #----------------------------------------------------------------


	#---------- Check if mouse is inside "SWITCH PART" ----------
    start_part.x = SWITCH_PART_POSITION.x
    start_part.y = SWITCH_PART_POSITION.y
    end_part.x   = start_part.x + SWITCH_PART_SIZE
    end_part.y   = start_part.y + SWITCH_PART_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return ButtonPart.SWITCH
    #----------------------------------------------------------------
	
	
	#---------- Check if mouse is inside "RESET PART" ----------
    start_part.x = RESET_PART_POSITION.x
    start_part.y = RESET_PART_POSITION.y
    end_part.x   = start_part.x + RESET_PART_SIZE
    end_part.y   = start_part.y + RESET_PART_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return ButtonPart.RESET
    #----------------------------------------------------------------

    return ButtonPart.NONE
#----- _detect_clicked_part()


#----------------------------------------------------
#-------------       _set_icon()        -------------
#----------------------------------------------------
# Error: "Error: Loaded resource as image file, this will not work on export"
# https://godotengine.org/qa/43318/error-loaded-resource-as-image-file-this-will-not-work-export
func _set_icon():	
    # Set "Normal" Button Texture
    _g_normal_texture = load(g_icon_path)
    set_normal_texture(_g_normal_texture)
#----- _set_icon()