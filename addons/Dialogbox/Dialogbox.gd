"""
Thank you, for using this plugin in you project, this really means much to me.

To properly use the plugin consider reading the readme.md or just read the explanation
next to the variables under this text.

This plugin is still under development and right now only the basics of a dialogbox are implemented,
so if you have any issues with this plugin or have an idea, consider opening an issue on the Github repo: 
https://github.com/Schweini07/Dialogbox

Also feel free to use the font, the sound and the textbox from the resources folder.

#sound and textbox
Those two resource are made by me and are under no liscense, you can use it for non- and commercial products.

#font
The font is the SuperLegendBody font 
('res://addons/Dialogbox/resources/SuperLegendBoy-4w8Y.ttf') -> Free for non-commercial use,
you have to buy a liscense for commercial use. Website: https://www.dafont.com/de/super-legend-boy.font

There is also a Showcase scene in the resource folder with which you can experiment with the plugin.

plugin = Dialogbox
author= Laurenz 'Schweini' Reinthaler
version = "0.2"
"""


tool
extends NinePatchRect

#properties
export (bool) var use_visible_characters = true #If set true, the characters (letters) show up with the speed determined trough the speed property
export (float) var character_speed = 1 #Determines how fast the characters (letters) will show up. The smaller the number the faster the text will be.
export (bool) var play_sound = true #If set true, the sound will play after every character that showed up
export (bool) var use_input_trigger = true #If set true, after the end of every dialog, the plugin waits for the input_trigger
export (bool) var use_speedup = true
export (Array) var text #An Array. Can be used in the editor but is not recommended, it works better with code: show_text(["Hi", "how", "are", "you?"])
export (String) var input_trigger #The action which is used to confirm the next dialog (must be picked from the InputMap)
export (String) var input_speedup #The action that lets you speed up the text
export (float) var speedup_speed = 1
export (Vector2) var text_margin = Vector2(35, 10) #Is used to determine the position of the textbox (textbox = the text)
export (Vector2) var textbox_size = Vector2(256, 64) #The size of the text (not the font size, but the size of the whole text)
export (AudioStream) var sound #Is only played when use_visible_characters and play_sound is true; Plays after after every character
export (Font) var font #The font of the text
export (bool) var use_character_frame = false #A frame where you can see the characters expressions
export (Array) var frame_textures

#misc
var text_instance := preload("text.tscn").instance()
var hsplit_instance := preload("HSplitContainer.tscn").instance()
var text_node : RichTextLabel
var frame : TextureRect
var audio : AudioStreamPlayer
var frame_rect_size : Vector2
 
#signals
signal dialog_finished
signal input_triggered
signal finished

func _enter_tree():
	#container for the text
	var container = Container.new()
	container.anchor_right = 1
	container.anchor_bottom = 1
	
	container.margin_right = -text_margin.x
	container.margin_bottom = -text_margin.y
	container.margin_left = text_margin.x
	container.margin_top = text_margin.y
	
	container.name = "Container"
	add_child(container)
	
	if use_character_frame:
		container.add_child(hsplit_instance)
		
		text_node = $Container/HSplitContainer/text
		frame = $Container/HSplitContainer/frame
	else:
		#instance the text
		container.add_child(text_instance)
		
		text_node = $Container/text
		text_node.rect_size = textbox_size
		
	#set the text font
	if font != null:
		text_node.add_font_override("normal_font", font)
		
	#initalize the sound
	audio = AudioStreamPlayer.new()
	
	if sound != null:
		audio.set_stream(sound)
		
	add_child(audio)

func _ready():
	if text.size() > 0:
		show_text(text)

func show_text(textarray : Array, framearray : Array = [0]):
	show()
	
	var frame_array_count := -1
	var frame_count : int
	
	for text in textarray:
		if use_character_frame:
			frame_array_count += 1
			frame_count = framearray[frame_array_count]
			frame.texture = frame_textures[frame_count]
			
		text_node.set_visible_characters(0)
		text_node.set_bbcode(text)
		yield(get_tree(), "idle_frame")
		
		if use_visible_characters:
			for i in text_node.get_total_character_count():
				text_node.visible_characters += 1
				
					
				if sound != null && play_sound:
					audio.play()
					
				if Input.is_action_pressed(input_speedup) && use_speedup:
					yield(get_tree().create_timer(speedup_speed/50), "timeout")
					
				else:
					yield(get_tree().create_timer(character_speed/10), "timeout")
					
		else:
			text_node.set_visible_characters(-1)
			
		emit_signal("dialog_finished")
		
		if use_input_trigger:
			yield(self, "input_triggered")
		else:
			yield(get_tree().create_timer(1), "timeout")
			
	audio.stop()
	hide()
	
	emit_signal("finished")

func _input(event):
	if Input.is_action_just_pressed(input_trigger):
		emit_signal("input_triggered")

func _exit_tree():
	$Container.queue_free()
