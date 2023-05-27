extends Node

"""
WARNING!!!

Settingers may not be used to save each DVD save game data!!!
DO NOT & NEVER use Settinger to save game!!!
Please make own DVD json or whatever save file in user://GameDVDCardtridges/YourGame instead.

If you lost or reset user://Pengaturan/Setelan.json, you'll lose your game save too! oof!!! (& we unable to be responsible for that file loss)
So make sure game save is separate from Setelan.json.
This way also make easy to backup game saves, and handle particular gamesave if
a save on a DVD had trouble or whatever.
"""

"""
PERHATIAN!!!

Settingers tidak boleh dipakai untuk menyimpan data simpan game setiap DVD!!!
JANGAN & JANGAN PERNAH menggunakan Settinger untuk menyimpan game!!!
Mohon gunakan json atau file simpan terserah pada DVD itu sendiri di user://GameDVDCardtridges/GameElu sebaiknya.

Jika Anda kehilangan atau mereset user://Pengaturan/Setelan.json, Anda akan kehilangan simpanan game Anda juga! oof!!! (& kami tidak dapat bertanggung jawab atas keguguran file tersebut)
Jadi pastikan simpan game terpisah dari Setelan.json.
Ini juga akan mempermudah mencadangkan simpanan2 game, dan menangani simpanan game tertentu bila terjadi masalah pada DVD tertentu atau ya gitulah.
"""

var tempAreYouSureDialog = preload("res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/AreYouSureDialog.tscn")
# Are you coding son
# https://youtu.be/d0B770ZM8Ic
# https://www.youtube.com/watch?v=L9Zekkb4ZXc
# https://godotengine.org/asset-library/asset/157
# YOINK! your coding is now mine! jk, it's still yours.
@onready var useJSON = true

var _DefaultSetting:Dictionary = {
	Version = 0,
	Nama = "a Dasandimian",
	ModPCKs={ #ModPCK
		Sample={
			Patho="",
			Replaceo=false,
			fromFolder=false
		},
	},
	DVDListCache={},
	AudioSetting = {
		MasterVolume = 0,
		MusicVolume = 0,
		SoundEffectVolume = 0,
		DummyVolume = 0,
		SpeechVolume = 0,
		RecordingVolume = 0,
	},
	DisplaySetting = {
		FullScreen = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)),
		Vsync = (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED),
	},
	ControllerMappings = {
		
	},
	Firebasers = {
		RememberMe = false
	},
	PleaseResetMe = false,
	Eggsellents = {},
}

"Total SettingData must be private! so do your save data! use _ to private. For security reason in case a mod PCK has malicious intents"
"SettingData total harus pribadi! juga dengan data simpanmu! gunakan _ untuk mempribadikan. Demi keamanan jika seandainya sebuah mod PCK memiliki niat jahat."
@onready var _SettingData:Dictionary = {
	Version = 0,
	Nama = "a Dasandimian",
	ModPCKs={
		
	},
	PleaseResetMe = false,
	AudioSetting = {
		MasterVolume = 0,
		MusicVolume = 0,
		SoundEffectVolume = 0,
		DummyVolume = 0,
		SpeechVolume = 0,
	},
	DVDListCache={},
	DisplaySetting = {
		FullScreen = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)),
		Vsync = (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED),
	},
	ControllerMappings = {},
	Firebasers = {
		RememberMe = false
	},
	Eggsellents = {},
}
var SettingFile:FileAccess
var SettingFolder:DirAccess
const SettingDirectory:String = "user://Pengaturan/"
var SettingPath:String = SettingDirectory + "Setelan.simpan"
var SettingJson:String = SettingDirectory + "Setelan.json"

var TheFirstTime : bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum DialogReason  {Nothing, ResetMe}
var SelectDialogReason
func prepareDialog():
	var instanceDialog = tempAreYouSureDialog.instantiate()
	add_child(instanceDialog)
	
	pass

func _dialog_Yes():
	pass

func _dialog_No():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	prepareDialog()
	
	SettingLoad()
	pass # Replace with function body.
func get_settings () -> Dictionary:
	return _SettingData
	pass

func get_setting(which:String):
	return _SettingData[which]
	pass

func ApplySetting():
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), SettingData.AudioSetting.MasterVolume)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),SettingData.AudioSetting.MusicVolume)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffect"),SettingData.AudioSetting.SoundEffectVolume)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dummy"),SettingData.AudioSetting.DummyVolume)
	
	for manyAudioVol in AudioServer.get_bus_count():
		if _SettingData.AudioSetting.has(AudioServer.get_bus_name(manyAudioVol) + "Volume"):
			AudioServer.set_bus_volume_db(manyAudioVol, _SettingData.AudioSetting[AudioServer.get_bus_name(manyAudioVol) + "Volume"])
		pass
	
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (_SettingData.DisplaySetting.FullScreen) else Window.MODE_WINDOWED
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (_SettingData.DisplaySetting.Vsync) else DisplayServer.VSYNC_DISABLED)
	pass

func SettingLoad():
#	SettingFile = FileAccess.new()
	if SettingFile.file_exists(SettingPath) && not useJSON:
		var werror = SettingFile.open(SettingPath, FileAccess.READ)
		match(werror):
			OK:
				TheFirstTime = false
				_SettingData = SettingFile.get_var()
				
				
				ApplySetting()
				SettingFile.close()
				print("Setting Loaded BIN Dictionary")
				pass
			_:
				print('Werror Loading File BIN Dictionary')
				TheFirstTime = true
				pass
		pass
	elif SettingFile.file_exists(SettingJson) && useJSON:
		var werror = SettingFile.open(SettingJson, FileAccess.READ)
		match(werror):
			OK:
				TheFirstTime = false
				var test_json_conv = JSON.new()
				test_json_conv.parse(SettingFile.get_as_text())
				_SettingData = test_json_conv.get_data()
				
				ApplySetting()
				SettingFile.close()
				print("Setting Loaded JSON")
			_:
				print('Werror Loading File JSON')
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
	#checkForResetMe() #doesn't work. Singleton cannot display driver?
	pass

var ResetSay = "Reset Factory DIP switch is on! Re"
func checkForResetMe():
	if _SettingData["PleaseResetMe"]:
		SelectDialogReason = DialogReason.ResetMe
		var theDialog = get_node("AreYouSureDialog")
		theDialog.SpawnDialogWithText(ResetSay)
		var whatAnswer = await theDialog.YesOrNoo
		if whatAnswer:
			engageFactoryReset()
		pass
	pass

func engageFactoryReset():
	TheFirstTime = true
	SettingSave()
	ApplySetting()
	pass

func ResetControllerMaps():
	InputMap.load_from_project_settings()
	var Actions = InputMap.get_actions()
	var EachActionContains
	#SettingData.ControllerMappings = Actions
	for everye in Actions:
		EachActionContains = InputMap.action_get_events(everye)
		_SettingData.ControllerMappings[String(everye)] = EachActionContains
	pass

func ResetFirstTimer():
#	_SettingData = _DefaultSetting
	
	for manyAudioVol in AudioServer.get_bus_count():
			_SettingData.AudioSetting[AudioServer.get_bus_name(manyAudioVol) + "Volume"] = AudioServer.get_bus_volume_db(manyAudioVol)
			pass
	
	ResetControllerMaps()
	
	TheFirstTime = false
	pass

func RenameGlobally(nama:String):
	_SettingData.Nama = nama
	pass

func SettingSave():
	
	if TheFirstTime:
		ResetFirstTimer()
		pass
	
#	SettingFolder = DirAccess.new()
	if !SettingFolder.dir_exists(SettingDirectory):
		SettingFolder.make_dir_recursive(SettingDirectory)
		pass
	
#	SettingFile = FileA.new()
	var werror = SettingFile.open(SettingPath, FileAccess.WRITE)
	match(werror):
		OK:
			SettingFile.store_var(_SettingData)
			SettingFile.close()
			print("Setting Bin Saved")
			pass
		_:
			print('Werror Saving File Bin code ', werror)
			pass
#	SettingFile = File.new()
	werror = SettingFile.open(SettingJson, FileAccess.WRITE)
	match(werror):
		OK:
			# https://godotengine.org/asset-library/asset/157
			# https://www.youtube.com/watch?v=L9Zekkb4ZXc
			var SettingJsonBeautiful = JSONBeautifier.beautify_json(JSON.new().stringify(_SettingData))
			SettingFile.store_string(SettingJsonBeautiful)
			SettingFile.close()
			print("Setting Json Saved")
			pass
		_:
			print('Werror Saving File Json code ', werror)
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setDVDListCache(entire:Dictionary):
	_SettingData.DVDListCache = entire

func getDVDListCache() -> Dictionary:
	if not _SettingData.has("DVDListCache"):
		_SettingData["DVDListCache"] = {
			templateHexagon = {
			id= "template-hexagon",
			Title= "Template Hexagon Engine",
			IconUrl= "res://Sprites/HexagonEngineSign.png",
			BootThisTscene= "res://GameDVDCardtridge/TemplateHexagonEngine/bootThisLegacyHexagonEngine.tscn",
			CatalogueBanner= "",
			DVDCover= "",
			isSelectable= true,
			hidden= false,
			actuallyBootJsonPath= "",
			requiredEggsellents= [],
			args= ["", ""],
			HoverEffect= true,
			SelectedEffect= true,
			HoveredImage= "res://Sprites/ConsoleHover.png",
			HoveredAudio= "res://Audio/Musik/Floaters.ogg",
			HoveredAudioStartSec= 12.08,
			HoveredAudioVolume= -15.0,
			SelectedImage= "res://Sprites/ConsoleLaunch.png",
			SelectedAudio= "res://Audio/EfekSuara/425728__moogy73__click01.wav",
			SelectedAudioVolume= 0.0
			}
		}
		pass
	return _SettingData.DVDListCache

func setModPCKs(entire:Dictionary):
	_SettingData.ModPCKs = entire

func getModPCKs() -> Dictionary:
	if not _SettingData.has("ModPCKs"):
		#print("No Mod PCK dictionary")
		_SettingData["ModPCKs"] = {
			Sample={
			Patho="",
			Replaceo=false,
			#fromFolder=false
			},
		}
	return _SettingData.ModPCKs

func addEggsellent(name:String, value):
	_SettingData["Eggsellents"][name] = value
	pass

func fetchEggsellent(which):
	return _SettingData["Eggsellents"][which]

func fetchEggsellentAll() -> Dictionary:
	if not _SettingData.has("Eggsellents"):
		_SettingData["Eggsellents"] = {}
	return _SettingData["Eggsellents"]

func setVolume(VolName:String, value:float):
	_SettingData["AudioSetting"][VolName] = value
	pass

func getVolume(VolName:String) -> float:
	return _SettingData["AudioSetting"][VolName]

func setDisplay(name:String, value):
	_SettingData["DisplaySetting"][name] = value
	pass

func getDisplay(name:String):
	return _SettingData["DisplaySetting"][name]

func setNama(nama:String):
	# Rename Globally function
	_SettingData["Nama"] = nama
	pass

func getNama() -> String:
	return _SettingData["Nama"]

func cancelReset():
	_SettingData["PleaseResetMe"] = false

func checkReset() -> bool:
	return _SettingData["PleaseResetMe"]

func getControllerMap() -> Dictionary:
	return _SettingData.ControllerMappings
	pass

func setFirebaser(name:String,value):
	_SettingData.Firebasers[name] = value
	pass

func getFirebaser(name:String):
	return _SettingData.Firebasers[name]
