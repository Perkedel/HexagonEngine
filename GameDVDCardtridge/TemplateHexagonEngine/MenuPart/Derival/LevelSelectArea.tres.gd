extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var Your3DSpaceLevel
export(PackedScene) var Your2DSpaceLevel
export(Texture) var LevelBannerThumbnail
export(String) var LevelTitleg

export(bool) var a2DSpaceReportHP = false
export(bool) var a3DSpaceReportHP = false
export(bool) var a2DSpaceReportScore = false
export(bool) var a3DSpaceReportScore = false
# https://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#exports
export(String, MULTILINE) var LevelDescription

# Called when the node enters the scene tree for the first time.
func _ready():
	#for TemplateLevelCardings
	PreConnectCards()
	pass # Replace with function body.

func PreConnectCards():
	for LevelCardings in $ScrollContainer/HBoxContainer.get_children():
		# https://www.youtube.com/watch?v=sKuM5AzK-uA&t=1517s
		#LevelCardings.connect("PleaseLoadThisLevelOf", self, "_ReceivesSignalClick", LevelCardings.Your3DSpaceLevel, LevelCardings.Your2DSpaceLevel, LevelCardings.LevelBannerThumbnail, LevelCardings.LevelTitleg, LevelCardings.LevelDescription)
		LevelCardings.connect("PleaseLoadThisLevelOf",self, "_ReceivesSignalClick")
		print("Level Cards", LevelCardings)
		LevelCardings.connect("AlsoPlsConnectThisReportStatus", self, "_ReceiveSignalStatus")
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
func LoadThisLevelOfThat():
	print("Load This Level of that")
	emit_signal("PleaseLoadThisLevelOf", Your3DSpaceLevel, Your2DSpaceLevel, LevelBannerThumbnail, LevelTitleg, LevelDescription)
	emit_signal("AlsoPlsConnectThisReportStatus",a3DSpaceReportHP,a2DSpaceReportHP,a3DSpaceReportScore,a2DSpaceReportScore)
	pass

func _ReceivesSignalClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	print("Level Select Gets Signal %s %s", a3DScapePacked, a2DSpacePacked)
	Your3DSpaceLevel = a3DScapePacked
	Your2DSpaceLevel = a2DSpacePacked
	LevelBannerThumbnail = LevelThumb
	LevelTitleg = LevelTitle
	LevelDescription = LevelDesc
	LoadThisLevelOfThat()
	pass

signal AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
func _ReceiveSignalStatus(a3DReportsHP, a2DReportsHP,a3DReportsScore,a2DReportsScore):
	a2DSpaceReportHP = a2DReportsHP
	a3DSpaceReportHP = a3DReportsHP
	a2DSpaceReportScore = a2DReportsScore
	a3DSpaceReportScore = a3DReportsScore
	emit_signal("AlsoPlsConnectThisReportStatus",a3DSpaceReportHP,a2DSpaceReportHP,a3DSpaceReportScore,a2DSpaceReportScore)
	pass
