extends Popup

class_name MusicNamePop

export(Texture) var albumPic:Texture = load("res://Sprites/MavrickleIcon.png")
export(String) var title = "Title"
export(String) var artist = "Artist"
export(String) var license = "CC4.0-BY-SA"
export(String) var source = "https://cointr.ee/joelwindows7"
export(float) var howLong = .5
export(float) var hideAfterIn = 5

onready var tween = $Tween
onready var AlbumPic = $HBoxContainer/AlbumPicture
onready var Title = $HBoxContainer/TextLabels/Title
onready var Artist = $HBoxContainer/TextLabels/Artist
onready var License = $HBoxContainer/TextLabels/License
onready var Source = $HBoxContainer/TextLabels/Source
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func processTheName(theTitle:String="Untitled",theArtist:String="Unknown",theLicense="??? license",theSource:String="??? sourced",theImage:Texture=preload("res://Sprites/MavrickleIcon.png")):
	title = theTitle
	artist = theArtist
	license = theLicense
	source = theSource
	albumPic = theImage
	
	# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
	# https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-create-from-image
	# 
	var itex = ImageTexture.new()
	var img = Image.new()
	img.load(albumPic.get_path())
	itex.create_from_image(img)
	
	AlbumPic.texture = albumPic
	Title.text = title
	Artist.text = artist
	License.text = license
	Source.text = source
	pass

func popTheName(forHowLong:float = 5.0,NoAnimation:bool = false):
	hideAfterIn = forHowLong
	show()
	if not NoAnimation:
		tween.interpolate_property(self,"rect_position",Vector2(-rect_size.x,rect_position.y),Vector2(0,rect_position.y),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN )
		tween.start()
		yield(tween,"tween_completed")
	yield(get_tree().create_timer(hideAfterIn),"timeout")
	if not NoAnimation:
		tween.interpolate_property(self,"rect_position",Vector2(0,rect_position.y),Vector2(-rect_size.x,rect_position.y),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN )
		tween.start()
		yield(tween,"tween_completed")
	hide()
	pass

func receiveDictionaryOfMusicName(thisOne:Dictionary):
	processTheName(thisOne["title"],thisOne["artist"],thisOne["license"],thisOne["source"],thisOne["albumPic"])
	pass

func forceHide():
	tween.stop_all()
	hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AlbumPic.texture
#	Title.text = title
#	Artist.text = artist
#	License.text = license
#	Source.text = source
	pass
