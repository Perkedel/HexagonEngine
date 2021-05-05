#*******************************************************************************#
#  ExtendGizmo.gd                                                               #
#*******************************************************************************#
#                             This file is part of:                             #
#                                    EXTEND                                     #
#                    https://github.com/hoontee/godot-extend                    #
#*******************************************************************************#
#  Copyright (c) 2020 hoontee @ Iron Stag Games.                                #
#                                                                               #
#  Extend is free software: you can redistribute it and/or modify               #
#  it under the terms of the GNU Affero General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or            #
#  (at your option) any later version.                                          #
#                                                                               #
#  Extend is distributed in the hope that it will be useful,                    #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of               #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                #
#  GNU Affero General Public License for more details.                          #
#                                                                               #
#  You should have received a copy of the GNU Affero General Public License     #
#  along with Extend.  If not, see <https://www.gnu.org/licenses/>.             #
#*******************************************************************************#

extends EditorSpatialGizmo

const snap := 0.05
const snap_key := KEY_CONTROL
const scale_all_key := KEY_SHIFT

var spatial: Spatial
var gt: Transform
var scale: Vector3
var dragging := false

func redraw() -> void:
	clear()
	spatial = get_spatial_node()
	var lines = PoolVector3Array()
	lines.push_back(Vector3(0.5, 0.5, 0.5))
	lines.push_back(Vector3(-0.5, 0.5, 0.5))
	lines.push_back(Vector3(0.5, -0.5, 0.5))
	lines.push_back(Vector3(-0.5, -0.5, 0.5))
	lines.push_back(Vector3(0.5, 0.5, -0.5))
	lines.push_back(Vector3(-0.5, 0.5, -0.5))
	lines.push_back(Vector3(0.5, -0.5, -0.5))
	lines.push_back(Vector3(-0.5, -0.5, -0.5))
	
	lines.push_back(Vector3(0.5, 0.5, 0.5))
	lines.push_back(Vector3(0.5, -0.5, 0.5))
	lines.push_back(Vector3(-0.5, -0.5, 0.5))
	lines.push_back(Vector3(-0.5, 0.5, 0.5))
	lines.push_back(Vector3(0.5, 0.5, -0.5))
	lines.push_back(Vector3(0.5, -0.5, -0.5))
	lines.push_back(Vector3(-0.5, 0.5, -0.5))
	lines.push_back(Vector3(-0.5, -0.5, -0.5))
	
	lines.push_back(Vector3(0.5, 0.5, 0.5))
	lines.push_back(Vector3(0.5, 0.5, -0.5))
	lines.push_back(Vector3(-0.5, 0.5, 0.5))
	lines.push_back(Vector3(-0.5, 0.5, -0.5))
	lines.push_back(Vector3(0.5, -0.5, 0.5))
	lines.push_back(Vector3(0.5, -0.5, -0.5))
	lines.push_back(Vector3(-0.5, -0.5, 0.5))
	lines.push_back(Vector3(-0.5, -0.5, -0.5))
	
	var handles := PoolVector3Array()
	handles.push_back(Vector3(0.5, 0, 0))
	handles.push_back(Vector3(0, 0.5, 0))
	handles.push_back(Vector3(0, 0, 0.5))
	handles.push_back(Vector3(-0.5, 0, 0))
	handles.push_back(Vector3(0, -0.5, 0))
	handles.push_back(Vector3(0, 0, -0.5))
	add_lines(lines, get_plugin().get_material("lines", self))
	add_handles(handles, get_plugin().get_material("handles", self))

func set_handle(index: int, camera: Camera, point: Vector2) -> void:
	if not dragging:
		gt = spatial.global_transform
		scale = spatial.scale
		dragging = true
		get_plugin().emit_signal("start_drag", spatial)
	
	var gi: Transform
	
	match index:
		0:
			gi = gt.orthonormalized().translated(Vector3(-scale.x*0.5, 0, 0)).affine_inverse()
		1:
			gi = gt.orthonormalized().translated(Vector3(0, -scale.y*0.5, 0)).affine_inverse()
		2:
			gi = gt.orthonormalized().translated(Vector3(0, 0, -scale.z*0.5)).affine_inverse()
		3:
			gi = gt.orthonormalized().translated(Vector3(scale.x*0.5, 0, 0)).affine_inverse()
		4:
			gi = gt.orthonormalized().translated(Vector3(0, scale.y*0.5, 0)).affine_inverse()
		5:
			gi = gt.orthonormalized().translated(Vector3(0, 0, scale.z*0.5)).affine_inverse()
	
	var ray_from := camera.project_ray_origin(point)
	var ray_dir := camera.project_ray_normal(point)
	
	var sg := [ gi.xform(ray_from), gi.xform(ray_from + ray_dir * 16384) ]
	
	var axis: Vector3
	if index > 2:
		axis[index%3] = -1.0
	else:
		axis[index%3] = 1.0
	var arr := Geometry.get_closest_points_between_segments(Vector3.ZERO, axis * 4096, sg[0], sg[1]);
	var d := arr[1][index%3]
	if Input.is_key_pressed(snap_key):
		d = stepify(d, snap)
	else:
		d = stepify(d, 0.001)
	if index > 2:
		d = max(-d, 0.001)
	else:
		d = max(d, 0.001)
	
	match index:
		0:
			spatial.global_transform.origin = gt.orthonormalized().translated(Vector3(d*0.5 - 0.5*scale.x, 0, 0)).origin
		1:
			spatial.global_transform.origin = gt.orthonormalized().translated(Vector3(0, d*0.5 - 0.5*scale.y, 0)).origin
		2:
			spatial.global_transform.origin = gt.orthonormalized().translated(Vector3(0, 0, d*0.5 - 0.5*scale.z)).origin
		3:
			spatial.global_transform.origin = gt.orthonormalized().translated(Vector3(-d*0.5 + 0.5*scale.x, 0, 0)).origin
		4:
			spatial.global_transform.origin = gt.orthonormalized().translated(Vector3(0, -d*0.5 + 0.5*scale.y, 0)).origin
		5:
			spatial.global_transform.origin = gt.orthonormalized().translated(Vector3(0, 0, -d*0.5 + 0.5*scale.z)).origin
	
	if Input.is_key_pressed(scale_all_key):
		match index%3:
			0:
				spatial.scale = scale*(d/scale.x)
			1:
				spatial.scale = scale*(d/scale.y)
			2:
				spatial.scale = scale*(d/scale.z)
	else:
		match index%3:
			0:
				spatial.scale = Vector3(d, scale.y, scale.z)
			1:
				spatial.scale = Vector3(scale.x, d, scale.z)
			2:
				spatial.scale = Vector3(scale.x, scale.y, d)

func commit_handle(_index: int, _restore, cancel := false) -> void:
	dragging = false
	if cancel:
		spatial.global_transform = gt
		spatial.scale = scale
	else:
		gt = spatial.global_transform
		scale = spatial.scale
		get_plugin().emit_signal("end_drag", spatial)

func get_handle_name(_index: int) -> String:
	return "Extend"

func get_handle_value(_index: int) -> String:
	return String(spatial.scale - scale)
