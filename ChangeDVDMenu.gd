extends Control

enum LoadInContext {ImportDVD, LoadCustomDVD}
var LoadWhichContext
var importDVDmodeWayhemAdd = false
var zetrixViewport
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()
signal updateSelectionAssets(hoverImage,launchImage,hoverAudio,launchAudio)
signal DVDListRefreshed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ReceiveZetrixViewport(getIt:Viewport):
	zetrixViewport = getIt
	$JustZetrixVRViewer.ReceiveZetrixViewport(zetrixViewport)
	pass

func RefreshDVDs():
	$JustWorkingMenu.refreshDVDs()
	pass

func SaveDVDListCache():
	$JustWorkingMenu.saveDVDListCache()
	pass

func LoadDVDListCache():
	$JustWorkingMenu.loadDVDListCache()
	pass

signal ShutdownButton

signal ShutdownHexagonEngineNow
func _on_JustWorkingAreYouSure_confirmed():
	hide()
	emit_signal("ShutdownHexagonEngineNow")
	pass # Replace with function body.

func ShowMeSelf():
	show()
	$JustWorkingMenu.InitMeSelf()
	pass

func ImportThatDVDToday(path):
	if not importDVDmodeWayhemAdd:
		# https://docs.godotengine.org/en/stable/getting_started/workflow/export/exporting_pcks.html
		var succession = ProjectSettings.load_resource_pack(path,true)
		if succession:
			print("\n\nNew DVD has been imported yay!!! \n", path)
		else:
			printerr("\n\nFaile Import DVD!! Warm and bad\n", path)
	else:
		# https://github.com/godotengine/godot-docs/issues/154#issuecomment-221551632
		print("\n\nPCK Packer add file\n\n")
		var packer = PCKPacker.new()
		packer.pck_start(path,0)
		packer.add_file("GameDVDCartridge","res://ImportDVDCartridge/")
		packer.flush(true)
	pass

func _on_JustWorkingMenu_PressShutDown():
	$JustWorkingAreYouSure.popup()
	pass # Replace with function body.

signal ItemClickEnter(Index, pathOfThis)
signal ItemClickEnterName(pathOfThis)
func _on_JustWorkingMenu_ItemClickEnter(Index, pathOfThis):
	emit_signal("ItemClickEnter",Index, pathOfThis)
	emit_signal("ItemClickEnterName",pathOfThis)
	print("Item Click Enter No. " + String(Index), " which is \n" + pathOfThis,"\nyeah")
	pass # Replace with function body.

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			print("Quito Introduce")
			$JustWorkingAreYouSure.popup()
			pass
		pass
	pass

func _notification(what): #add heurestic of changeDVD menu! check visible of change dvd menu
	if visible:
		if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			if $JustWorkingAreYouSure.visible:
				$JustWorkingAreYouSure.hide()
				pass
			else:
				$JustWorkingAreYouSure.popup()
				pass
			pass
		if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT && OS.get_name().nocasecmp_to("windows") != 0:
			pass
		pass
	pass


func _on_JustWorkingMenu_openSetting():
	$JustWorkingSetting.popup()
	pass # Replace with function body.


func _on_JustWorkingSetting_confirmed():
	$JustWorkingMenu.reloadAccountName()
	pass # Replace with function body.


func _on_JustWorkingSetting_custom_action(action):
	pass # Replace with function body.


func _on_JustWorkingSetting_popup_hide():
	$JustWorkingMenu.reloadAccountName()
	pass # Replace with function body.


func _on_JustWorkingMenu_loadMoreDVDsNow():
	LoadWhichContext = LoadInContext.LoadCustomDVD
	$SelectFileLoadingMode.popup_centered()
	pass # Replace with function body.


func _on_SelectFileLoadingMode_FileAccessModeSelected(Which):
	$JustAFileDialog.access = Which
	match LoadWhichContext:
		LoadInContext.ImportDVD:
			$JustAFileDialog.set_filters(PoolStringArray([
				"*.pck; Godot Resource Pack",
				"*.zip; Godot Resource ZIP"
			]))
			pass
		LoadInContext.LoadCustomDVD:
			$JustAFileDialog.set_filters(PoolStringArray([
				"*.tscn; Godot Tscene",
				"*.scn; Godot scene"
			]))
			pass
		_:
			pass
		
	$JustAFileDialog.popup_centered()
	pass # Replace with function body.

signal CustomLoadMoreDVD(path)
func _on_JustAFileDialog_file_selected(path):
	match LoadWhichContext:
		LoadInContext.ImportDVD:
			print("\n\nImport DVD now\n\n")
			ImportThatDVDToday(path)
			pass
		LoadInContext.LoadCustomDVD:
			print("\n\nLoad custom DVD\n\n")
			emit_signal("CustomLoadMoreDVD",path)
			pass
		_:
			pass
	
	pass # Replace with function body.


func _on_JustWorkingMenu_importModPCKnow():
	print("time to import PCK")
	LoadWhichContext = LoadInContext.ImportDVD
	$SelectFileLoadingMode.popup_centered()
	pass # Replace with function body.


func _on_JustWorkingMenu_shareBootInfoJson(JsonOfIt, pathOfIt):
	pass # Replace with function body.


func _on_JustWorkingMenu_viewVRImageNow():
	$JustZetrixVRViewer.popup_centered()
	pass # Replace with function body.


func _on_JustWorkingSetting_ShowModListMenuNow():
	$JustModListToLoad.popup_centered()
	pass # Replace with function body.


func _on_JustWorkingMenu_updateSelectionAssets(hoverImage, launchImage, hoverAudio, launchAudio):
	emit_signal("updateSelectionAssets",hoverImage,launchImage,hoverAudio,launchAudio)
	pass # Replace with function body.


func _on_JustWorkingMenu_DVDListRefreshed():
	emit_signal("DVDListRefreshed")
	pass # Replace with function body.
