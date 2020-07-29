extends Node

# Are you coding son
# https://youtu.be/d0B770ZM8Ic

onready var SettingData = {
	Nama = "a Dasandimian",
	AudioSetting = {
		MasterVolume = 0,
		MusicVolume = 0,
		SoundEffectVolume = 0,
		DummyVolume = 0,
	},
	DisplaySetting = {
		FullScreen = OS.is_window_fullscreen(),
		Vsync = OS.vsync_enabled,
	}
}
var SettingFile
var SettingFolder
const SettingDirectory = "user://Pengaturan/"
var SettingPath = SettingDirectory + "Setelan.simpan"

var TheFirstTime : bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SettingLoad()
	pass # Replace with function body.

func ApplySetting():
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), SettingData.AudioSetting.MasterVolume)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),SettingData.AudioSetting.MusicVolume)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffect"),SettingData.AudioSetting.SoundEffectVolume)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dummy"),SettingData.AudioSetting.DummyVolume)
	
	for manyAudioVol in AudioServer.get_bus_count():
		AudioServer.set_bus_volume_db(manyAudioVol, SettingData.AudioSetting[AudioServer.get_bus_name(manyAudioVol) + "Volume"])
		pass
	
	OS.set_window_fullscreen(SettingData.DisplaySetting.FullScreen)
	OS.set_use_vsync(SettingData.DisplaySetting.Vsync)
	pass

func SettingLoad():
	SettingFile = File.new()
	if SettingFile.file_exists(SettingPath):
		var werror = SettingFile.open(SettingPath, File.READ)
		match(werror):
			OK:
				TheFirstTime = false
				SettingData = SettingFile.get_var()
				
				
				ApplySetting()
				SettingFile.close()
				print("Setting Loaded")
				pass
			_:
				print('Werror Loading File')
				TheFirstTime = true
				pass
		pass
	else:
		print("The First Timer")
		TheFirstTime = true
		SettingSave()
		pass
	# ApplySetting()
	SettingFile.close()
	pass

func SettingSave():
	
	if TheFirstTime:
		SettingData = {
			Nama = "a Dasandimian",
			AudioSetting = {
				
			},
			DisplaySetting = {
				FullScreen = OS.is_window_fullscreen(),
				Vsync = OS.is_vsync_enabled(),
			}
		}
		
		for manyAudioVol in AudioServer.get_bus_count():
			SettingData.AudioSetting[AudioServer.get_bus_name(manyAudioVol) + "Volume"] = AudioServer.get_bus_volume_db(manyAudioVol)
			pass
		pass
	
	SettingFolder = Directory.new()
	if !SettingFolder.dir_exists(SettingDirectory):
		SettingFolder.make_dir_recursive(SettingDirectory)
		pass
	
	SettingFile = File.new()
	var werror = SettingFile.open(SettingPath, File.WRITE)
	match(werror):
		OK:
			SettingFile.store_var(SettingData)
			
			SettingFile.close()
			print("Setting Saved")
			pass
		_:
			print('Werror Saving File')
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
