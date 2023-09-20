extends Node

@onready var DVDSlot = $DVDSlot

@export var mainBootJsonPath:String = 'res://Ga'
@export var mainDVD:PackedScene = preload("res://GameDVDCardtridge/HexagonEngine-v3/HexagonEngineV3.tscn")
var toBeLoadedDVD:PackedScene

var instanceDVD:Node

func _zetrixInit():
	var theXR = XRServer.find_interface("OpenXR")
	if theXR:
		XRServer.add_interface(theXR)
	#zetrixViewport.hdr = false
#	changeDVDMenu.ReceiveZetrixViewport(zetrixViewport)
#	zetrixPreview.ReceiveZetrixViewport(zetrixViewport)
#	zetrixViewport.ReceiveRootViewport(get_viewport())
#	zetrixViewport.ReinstallOwnWorld()
	# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
	pass

func _sysInit():
	print("Welcome to Hexagon Engine")
	#Singletoner.theCoreOfIt = self
	Singletoner.iAmTheMainNode(self)
	print("Locate " + String(OS.get_executable_path()))
	_zetrixInit()
	OS.request_permissions()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_goBackToMainDVD()
	pass # Replace with function body.

func PlayDVD(LoadDVD:PackedScene):
#	emit_signal("DVDTryLoad")
	instanceDVD = LoadDVD.instantiate()
	DVDSlot.add_child(instanceDVD)
	Singletoner.thisIsDvdNode(instanceDVD)
#	ConnectCartridge()
	pass

func _goBackToMainDVD():
	PlayDVD(mainDVD)
	pass

func DoChangeDVDNow():
	print("Change DVD!")
	
	Singletoner.ResumeGameNow()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# return to main DVD
	_goBackToMainDVD()
	pass
	

func checkForResetMe():
	if await Settingers.checkForResetMe():
		#SelectDialogReason = DialogReason.ResetMe
		#var theDialog = $MetaMenu/AreYouSureDialog
		#theDialog.SpawnDialogWithText(ResetSay)
#		var whatAnswer = await theDialog.YesOrNoo
#		if whatAnswer:
#			Settingers.engageFactoryReset()
#		else:
#			#Settingers.SettingData["PleaseResetMe"] = false
#			Settingers.cancelReset()
		pass
		
	else:
		
		pass
#	$DVDCartridgeSlot.CheckDVD()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pressAMenuButton(whichIs:String,Argument:String):
	
	pass
