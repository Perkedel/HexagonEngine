extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var Your3DSpaceLevel
export(PackedScene) var Your2DSpaceLevel
export(Texture) var LevelBannerThumbnail
export(String) var LevelTitleg
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
		LevelCardings.connect("PleaseLoadThisLevelOf",self, "_ReveivesSignalClick")
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
func LoadThisLevelOfThat():
	emit_signal("PleaseLoadThisLevelOf", Your3DSpaceLevel, Your2DSpaceLevel, LevelBannerThumbnail, LevelTitleg, LevelDescription)
	pass

func _ReceivesSignalClick(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	Your3DSpaceLevel = a3DScapePacked
	Your2DSpaceLevel = a2DSpacePacked
	LevelBannerThumbnail = LevelThumb
	LevelTitleg = LevelTitle
	LevelDescription = LevelDesc
	LoadThisLevelOfThat()
	pass
