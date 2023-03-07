extends Control
class_name HexagonDisplay2D, "res://addons/HexagonDisplay2D/icon.png"
tool

export var displayLines: bool = false setget _displayLinesRefresh
export var lineThickness: float = 1.0 setget _lineThicknesRefresh
export var lineAbovePolygon: bool = false setget _lineAbovePolygonRefresh
export(Color) var lineColor = Color.white setget _lineColorRefresh
export(float,0,100) var fillRayTopLeft: float = 0.0 setget _fillRay1Refresh
export(float,0,100) var fillRayTopRight: float = 0.0 setget _fillRay2Refresh
export(float,0,100) var fillRayMiddleRight: float = 0.0 setget _fillRay3Refresh
export(float,0,100) var fillRayBottomRight: float = 0.0 setget _fillRay4Refresh
export(float,0,100) var fillRayBottomLeft: float = 0.0 setget _fillRay5Refresh
export(float,0,100) var fillRayMiddleLeft: float = 0.0 setget _fillRay6Refresh
export(Color) var fillRayTopLeftColor = Color.white setget _fillRay1ColorRefresh
export(Color) var fillRayTopRightColor = Color.white setget _fillRay2ColorRefresh
export(Color) var fillRayMiddleRightColor = Color.white setget _fillRay3ColorRefresh
export(Color) var fillRayBottomRightColor = Color.white setget _fillRay4ColorRefresh
export(Color) var fillRayBottomLeftColor = Color.white setget _fillRay5ColorRefresh
export(Color) var fillRayMiddleLeftColor = Color.white setget _fillRay6ColorRefresh
export(int) var z_index = 0 setget _zindexRefresh

var polygonForm: Polygon2D
var lineTopLeftBottomRight: Line2D
var lineTopRightBottomLeft: Line2D
var lineMiddle: Line2D
var polygonRays = []

func _zindexRefresh(nv):
	z_index = nv
	prepareHex()
func _lineAbovePolygonRefresh(nv):
	lineAbovePolygon = nv
	prepareHex()	
func _lineColorRefresh(nv):
	lineColor = nv
	prepareHex()
func _fillRay1ColorRefresh(nv):
	fillRayTopLeftColor = nv
	setPolygon()
func _fillRay2ColorRefresh(nv):
	fillRayTopRightColor = nv
	setPolygon()
func _fillRay3ColorRefresh(nv):
	fillRayMiddleRightColor = nv
	setPolygon()
func _fillRay4ColorRefresh(nv):
	fillRayBottomRightColor = nv
	setPolygon()
func _fillRay5ColorRefresh(nv):
	fillRayBottomLeftColor = nv
	setPolygon()
func _fillRay6ColorRefresh(nv):
	fillRayMiddleLeftColor = nv
	setPolygon()
func _fillRay1Refresh(nv):
	fillRayTopLeft = nv
	setPolygon()
func _fillRay2Refresh(nv):
	fillRayTopRight = nv
	setPolygon()
func _fillRay3Refresh(nv):
	fillRayMiddleRight = nv
	setPolygon()
func _fillRay4Refresh(nv):
	fillRayBottomRight = nv
	setPolygon()
func _fillRay5Refresh(nv):
	fillRayBottomLeft = nv
	setPolygon()
func _fillRay6Refresh(nv):
	fillRayMiddleLeft = nv
	setPolygon()	
func _lineThicknesRefresh(nv):
	lineThickness = nv
	prepareHex()
func _displayLinesRefresh(nv):
	displayLines = nv
	prepareHex()
func _onChanged():
	prepareHex()

func _init():
	self.connect("resized", self, "_onChanged")
	
	polygonForm = Polygon2D.new()
	polygonForm.texture = load("res://addons/HexagonDisplay2D/1x1.png")
	lineTopLeftBottomRight = Line2D.new()
	lineTopRightBottomLeft = Line2D.new()
	lineMiddle = Line2D.new()

	add_child(lineTopLeftBottomRight)
	add_child(lineTopRightBottomLeft)
	add_child(lineMiddle)

	add_child(polygonForm)

	#polygonForm.color = Color.webgray
	prepareHex()


func prepareHex():
	lineTopLeftBottomRight.width = lineThickness
	lineTopRightBottomLeft.width = lineThickness
	lineMiddle.width = lineThickness

	lineTopLeftBottomRight.visible = displayLines
	lineTopRightBottomLeft.visible = displayLines
	lineMiddle.visible = displayLines

	lineTopLeftBottomRight.default_color = lineColor
	lineTopRightBottomLeft.default_color = lineColor
	lineMiddle.default_color = lineColor

	lineTopLeftBottomRight.z_index = z_index
	lineTopRightBottomLeft.z_index = z_index
	lineMiddle.z_index = z_index
	polygonForm.z_index = z_index
	if lineAbovePolygon == false:
		polygonForm.z_index = z_index + 1
	else:
		lineTopLeftBottomRight.z_index = z_index + 1
		lineTopRightBottomLeft.z_index = z_index + 1
		lineMiddle.z_index = z_index + 1
	
	

	if lineMiddle.points.size() > 0:
		lineMiddle.remove_point(0)
		lineMiddle.remove_point(0)
	if lineTopRightBottomLeft.points.size() > 0:
		lineTopRightBottomLeft.remove_point(0)
		lineTopRightBottomLeft.remove_point(0)
	if lineTopLeftBottomRight.points.size() > 0:
		lineTopLeftBottomRight.remove_point(0)
		lineTopLeftBottomRight.remove_point(0)

	lineMiddle.add_point(Vector2(0, self.rect_size.y / 2))
	lineMiddle.add_point(Vector2(self.rect_size.x, self.rect_size.y / 2))

	lineTopLeftBottomRight.add_point(Vector2(self.rect_size.x / 10 * 3, 0))
	lineTopLeftBottomRight.add_point(Vector2(self.rect_size.x / 10 * 7, self.rect_size.y))

	lineTopRightBottomLeft.add_point(Vector2(self.rect_size.x / 10 * 7, 0))
	lineTopRightBottomLeft.add_point(Vector2(self.rect_size.x / 10 * 3, self.rect_size.y))

	polygonRays.clear()
	# oben links
	polygonRays.append(
		{
			"dir":
			(
				(lineTopLeftBottomRight.points[1] - lineTopLeftBottomRight.points[0]).normalized()
			),
			"pos": (lineTopLeftBottomRight.points[0] + lineTopLeftBottomRight.points[1]) / 2,
			"max": lineTopLeftBottomRight.points[0]
		}
	)
	# oben rechts
	polygonRays.append(
		{
			"dir":
			(
				(lineTopRightBottomLeft.points[1] - lineTopRightBottomLeft.points[0]).normalized()
			),
			"pos": (lineTopRightBottomLeft.points[0] + lineTopRightBottomLeft.points[1]) / 2,
			"max": lineTopRightBottomLeft.points[0]
		}
	)
	# mitte rechts
	polygonRays.append(
		{
			"dir":
			(
				(lineMiddle.points[1] - lineMiddle.points[0]).normalized()
				* -1
			),
			"pos": (lineMiddle.points[0] + lineMiddle.points[1]) / 2,
			"max": lineMiddle.points[1]
		}
	)

	# unten rechts
	polygonRays.append(
		{
			"dir":
			(
				(lineTopLeftBottomRight.points[1] - lineTopLeftBottomRight.points[0]).normalized()
				* -1
			),
			"pos": (lineTopLeftBottomRight.points[0] + lineTopLeftBottomRight.points[1]) / 2,
			"max": lineTopLeftBottomRight.points[1]

		}
	)

	# unten links
	polygonRays.append(
		{
			"dir":
			(
				(lineTopRightBottomLeft.points[1] - lineTopRightBottomLeft.points[0]).normalized()
				* -1
			),
			"pos": (lineTopRightBottomLeft.points[0] + lineTopRightBottomLeft.points[1]) / 2,
			"max": lineTopRightBottomLeft.points[1]

		}
	)

	# mitte links
	polygonRays.append(
		{
			"dir":
			(
				(lineMiddle.points[1] - lineMiddle.points[0]).normalized()
			),
			"pos": (lineMiddle.points[0] + lineMiddle.points[1]) / 2,
			"max": lineMiddle.points[0]
		}
	)
	
	polygonForm.polygon.resize(0)
	for i in range(polygonRays.size()):
		polygonForm.polygon.append(Vector2(0, 0))
		polygonRays[i]["initPos"] = polygonRays[i]["pos"]
		polygonRays[i]["secSize"] = (polygonRays[i]["max"] - polygonRays[i]["initPos"]) / 100

	setPolygon()


func setPolygon():
	var f = PoolVector2Array()
	var c = PoolColorArray()
	for i in range(polygonRays.size()):
		match i:
			0:
				polygonRays[i].pos = polygonRays[i].initPos + polygonRays[i]["secSize"] * fillRayTopLeft
				c.append(fillRayTopLeftColor)
			1:
				polygonRays[i].pos = polygonRays[i].initPos + polygonRays[i]["secSize"] * fillRayTopRight
				c.append(fillRayTopRightColor)
			2:
				polygonRays[i].pos = polygonRays[i].initPos + polygonRays[i]["secSize"] * fillRayMiddleRight
				c.append(fillRayMiddleRightColor)
			3:
				polygonRays[i].pos = polygonRays[i].initPos + polygonRays[i]["secSize"] * fillRayBottomRight
				c.append(fillRayBottomRightColor)
			4:
				polygonRays[i].pos = polygonRays[i].initPos + polygonRays[i]["secSize"] * fillRayBottomLeft
				c.append(fillRayBottomLeftColor)
			5:
				polygonRays[i].pos = polygonRays[i].initPos + polygonRays[i]["secSize"] * fillRayMiddleLeft
				c.append(fillRayMiddleLeftColor)
		f.append(polygonRays[i].pos)

	polygonForm.polygon = f
	polygonForm.uv = f
	polygonForm.vertex_colors = c
	pass
