tool
extends Node
class_name RandomSound, "res://addons/RandomSound/icon_random_sound.svg"

export(bool) var play_rnd setget play
export(int, 1, 5) var channels = 1 setget set_channels
export(float, 0.0, 1.0) var pitch_variation = 0
export(float) var base_pitch = 1
export(float, -15, 4) var base_volume = 0

var currentChannel = 0
var isReady = false

#Toolscript magic to add the scene components when importing from "Add child node"
func _enter_tree():
	if !get_node_or_null("Channels"):
		print("RandomSound:  Replacing scene with proto")
		call_deferred("_replace")
	else:
		print("RandomSound:  I have channels...", get_child_count())
func _replace():
	print("RandomSound:  ReplaceBy")
	replace_by(load("res://addons/RandomSound/RandomSound.tscn").instance())



func _ready():
	print("Setting up RandomSound..", name)
#	set_meta("_editor_icon", preload("res://sys/icon_random_sound.svg"))
	isReady = true

	channel_check()

func set_channels(val):
	channels = val
	currentChannel = 0
	if !isReady:  
#		print("Can't set channels from %s to %s.  Try again?" % [channels, val])
		return

	
	for o in $Channels.get_children():
		o.queue_free()

	yield(get_tree(), "idle_frame")
	
	for i in channels:
		var p:AudioStreamPlayer = AudioStreamPlayer.new()
		p.name = str(i)
		p.pause_mode = Node.PAUSE_MODE_PROCESS
		
		
		$Channels.add_child(p)
		p.owner = self
	

func play(val=true):
	if !isReady:  
		print("Can't play sound, not ready.  Try again?")
		return
	channel_check()

	if get_child_count() <= 1:  print("RandomSound (%s): No children to play" % name)
	
	var idx = randi() % get_child_count()
	var o = get_child(idx)
	var p = $Channels.get_child(currentChannel)
	
	#Try and try again.
	for i in range(10):
		if o is AudioStreamPlayer:
			break
		else:
			idx = randi() % get_child_count()
			o = get_child(idx)

	#Uh oh.  All 10 tries failed somehow.  This shouldn't happen... often!
	if not o is AudioStreamPlayer:
		print("RandomSound (%s): Non AudioStream child detected.  Aborting..." % name)
		return
	

	if Engine.editor_hint:
		print("RandomSound:  Playing %s on channel %s..." % [o.name, currentChannel])


	#Swap our properties with that of the object we want.
	p.stream = o.stream
	p.volume_db = o.volume_db + base_volume
	p.pitch_scale = o.pitch_scale * base_pitch
	p.mix_target = o.mix_target
	p.bus = o.bus

	#Now apply the overrides.

	if round(randf()):
		#Pitch up.
		p.pitch_scale +=  rand_range(0, pitch_variation)
	else:
		#Pitch down.
		var scl = p.pitch_scale * (1-(rand_range(0, pitch_variation)/2))
		
		if scl <= 0:  print(scl)
		p.pitch_scale = scl

	p.play()
	currentChannel = (currentChannel+1) % channels

#Run this to test to make sure the object is set up correctly.
func channel_check():
	#class_name doesn't preserve the parent scene if not an inherited scene.  Fix it.
	if !get_node_or_null("Channels"):
#		var p = Node.new()
#		p.name = "Channels"
#		add_child(p)
#		p.owner = self
		return
		pass


	if channels <= 0:  
		print ("ChannelCheck:  Channels are 0.  set channels to 1.")
		set_channels(1)
	elif $Channels.get_child_count() != channels:
		set_channels(channels)