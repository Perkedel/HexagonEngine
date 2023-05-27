@tool
extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var Your3DSpaceLevel: PackedScene
@export var Your2DSpaceLevel: PackedScene
@export var LevelBannerThumbnail: Texture2D
@export var LevelTitleg: String
@export var LoadThisCardButton: String
@export var a2DSpaceReportHP: bool = false
@export var a3DSpaceReportHP: bool = false
@export var a2DSpaceReportScore: bool = false
@export var a3DSpaceReportScore: bool = false
@export var KeepPlayingEvenOutOfFocus: bool = false
# https://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#exports
@export var LevelDescription # (String, MULTILINE)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func UpdateDetails():
	$LevelCardContainer/ImagePanel/LevelIconImage.texture = LevelBannerThumbnail
	$LevelCardContainer/TitleScroll/Title.text = LevelTitleg
	$LevelCardContainer/DescriptionScroll/RichTextLabel.text = LevelDescription
	$LevelCardContainer/PlayTheLevelButton.text = LoadThisCardButton
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	UpdateDetails()
	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
signal AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
signal canThisLevelPlayEvenOutOfFocus(mayI)

func LoadThisLevelOfThat():
	
	emit_signal("PleaseLoadThisLevelOf", Your3DSpaceLevel.get_path(), Your2DSpaceLevel.get_path(), LevelBannerThumbnail.get_path(), LevelTitleg, LevelDescription)
	#print("PleaseLoadThisLevelOf ", Your3DSpaceLevel.get_path()," | ", Your2DSpaceLevel.get_path()," | ", LevelBannerThumbnail.get_path(), " | ", LevelTitleg, " | ", LevelDescription)
	emit_signal("AlsoPlsConnectThisReportStatus",a3DSpaceReportHP,a2DSpaceReportHP,a3DSpaceReportScore,a2DSpaceReportScore)
	emit_signal("canThisLevelPlayEvenOutOfFocus",KeepPlayingEvenOutOfFocus)
	pass

func pressLoadLevelButton():
	print("Play The Level Button")
	LoadThisLevelOfThat()
	pass


func _on_PlayTheLevelButton_pressed():
	pressLoadLevelButton()
	pass # Replace with function body.


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.
