extends Panel

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
	UpdateDetails()
	pass # Replace with function body.

func UpdateDetails():
	$LevelCardContainer/ImagePanel/LevelIconImage.texture = LevelBannerThumbnail
	$LevelCardContainer/TitleScroll/Title.text = LevelTitleg
	$LevelCardContainer/DescriptionScroll/RichTextLabel.bbcode_text = LevelDescription
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
signal AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
func LoadThisLevelOfThat():
	
	emit_signal("PleaseLoadThisLevelOf", Your3DSpaceLevel.get_path(), Your2DSpaceLevel.get_path(), LevelBannerThumbnail.get_path(), LevelTitleg, LevelDescription)
	#print("PleaseLoadThisLevelOf ", Your3DSpaceLevel.get_path()," | ", Your2DSpaceLevel.get_path()," | ", LevelBannerThumbnail.get_path(), " | ", LevelTitleg, " | ", LevelDescription)
	emit_signal("AlsoPlsConnectThisReportStatus",a3DSpaceReportHP,a2DSpaceReportHP,a3DSpaceReportScore,a2DSpaceReportScore)
	pass


func _on_PlayTheLevelButton_pressed():
	print("Play The Level Button")
	LoadThisLevelOfThat()
	pass # Replace with function body.
