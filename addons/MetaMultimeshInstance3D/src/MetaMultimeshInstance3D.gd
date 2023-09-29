@tool
class_name MetaMultimeshInstance3D
extends MultiMeshInstance3D

# MIT License
#
# Copyright (c) 2023 Donn Ingle (donn.ingle@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


## This class is for making a Multimesh from a bunch of instance children.
## It lets you implode them back into a Multimesh and explode a Multimesh
## out into many instances again.
## You can also automatically make colliders for all transforms when it's imploded.
##
## TODO: Some mechanism to allow custom a collision mesh.


enum colliders{ DIRTY_SIMPLE, DIRTY_NORMAL, CLEAN_SIMPLE, CLEAN_NORMAL, TRIMESH, CUSTOM }
enum  {CAN_IMPLODE, CAN_EXPLODE}


const _tmpNodeName:String = "instances"


var shape_type:int=0:
	set(v):
		shape_type = v
		notify_property_list_changed()


func _init() -> void:
	_ensure_multimesh()


func _ensure_multimesh():
	if multimesh == null:
		multimesh = MultiMesh.new()
		multimesh.transform_format = MultiMesh.TRANSFORM_3D


## The dynamic Inspector gui
## Any name starting with "go_" is captured by the included
## inspectorbutton plugin and converted into a button.
var state:int
func _get_property_list():
	if Engine.is_editor_hint():
		# Try to discern the situation before we
		# draw any buttons.
		# Because the tests below use 'find_children',
		# and because the actual explode and implode
		# funcs rely on queue_free, there is a kind
		# of lag sometimes and these tests don't work
		# reliably. In that case, you will see implode
		# AND explode buttons in a way that does not
		# make sense.
		# Therefore: I test these AGAIN in the button
		# press handler before running explode or implode
		state = 0

		if _can_we_explode():
			state = CAN_EXPLODE
		else:
			# call the test as it sets some warning strings
			if _can_we_implode():
				state = CAN_IMPLODE

		update_configuration_warnings()

		var ret: Array = []
		ret.append({
		"name" : &"Meta Multi Mesh Tool",
		"type" : TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY
		})

		if state == CAN_IMPLODE:
			ret.append({
			"name" : &"Implode into Multimesh",
			"type" : TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
			})
			ret.append({
			"name": &"go_implode", #<-- becomes a button
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
			})

		if state == CAN_EXPLODE:
			ret.append({
			"name" : &"Explode to Instances",
			"type" : TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
			})
			ret.append({
			"name": &"go_explode", #<-- becomes a button
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
			})

		# Collider Sections
		if state == CAN_EXPLODE:
			ret.append({
			"name" : &"Choose collision shape",
			"type" : TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
			})
			ret.append({
			"name": &"shape_type",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Dirty-simple,Dirty-normal,Clean-simple,Clean-normal,Trimesh"
			#,Custom"
			## Custom is not finished yet. So remarked it out.
			})
			## This won't happen now.
#			if shape_type == colliders.CUSTOM:
#				ret.append({
#				"name": &"custom_mesh_3d",
#				"type": TYPE_OBJECT,
#				"hint": PROPERTY_HINT_RESOURCE_TYPE,
#				"hint string": "Mesh"
#				})
			ret.append({
			"name": &"go_make_colliders", #<-- becomes a button
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
			})
		return ret


## Button's signal sent from the inspectorbutton plugin
func _on_button_pressed(text:String):
	if Engine.is_editor_hint():
		_ensure_multimesh()
		match text.to_upper():
			"PRESS TO EXPLODE":
				# Just in case of timing issues, make sure:
				if _can_we_explode():
					_explode()
			"PRESS TO IMPLODE":
				# Just in case of timing issues, make sure:
				if _can_we_implode():
					_implode()
			"PRESS TO MAKE COLLIDERS":
				_make_colliders()

		#Do this last
		notify_property_list_changed()


## Overridden to display the actual warnings.
var warnings:Dictionary
func _get_configuration_warnings():
	var w:PackedStringArray
	var tmp
	if multimesh.mesh == null:
		tmp = "The multimesh has no mesh resource."
		w.append_array(PackedStringArray([tmp]))
		push_warning(tmp)

	if multimesh.instance_count == 0:
		tmp = "The multimesh has no instances (Add some MeshInstance3D children)."
		w.append_array(PackedStringArray([tmp]))
		push_warning(tmp)

	for warn in warnings.values():
		w.append_array(PackedStringArray([warn]))
		push_warning(warn)

	return w


func _can_we_explode()->bool:
	# Failure tests - leaves state unchanged
	if multimesh.mesh == null:
		return false
	if multimesh.instance_count == 0:
		return false
	return true


func _can_we_implode()->bool:
	# Do not allow implode when we have stuff in the multimesh
	# already - it will replace all that's in the mmesh
	# which is not what's expected.
	if multimesh.instance_count > 0:
		return false

	var mesh_children:Array = find_children("*", "MeshInstance3D", true)

	# Failure mode one
	if mesh_children.is_empty():
		warnings[1] = "There are no child nodes to implode into the multimesh."
		update_configuration_warnings()
		return false

	# Get the mesh from the first mi3d we encounter
	var themesh:Mesh = multimesh.mesh
	if not themesh:
		for m in mesh_children:
			if m.mesh:
				themesh = m.mesh
				break

	# Failure mode 2
	if not themesh:
		warnings[2] = "Could not find a mesh in any of the children." \
		+ "Try dropping one into any of the MeshInstance3D child nodes."
		update_configuration_warnings()
		return false

	warnings.erase(1)
	warnings.erase(2)
	return true


## EXPLODE every single instance in the multimesh into
## a stand-alone MeshInstance3D.
## Assumes it can explode - no tests done within
func _explode():
	var node_instances : Node3D
	node_instances = get_node_or_null(_tmpNodeName)
	if node_instances == null:
		node_instances = Node3D.new()
		node_instances.name = _tmpNodeName
		add_child(node_instances)
		node_instances.set_owner(self.owner)
		node_instances.global_transform = global_transform

	for index in multimesh.instance_count:
		var minstance : MeshInstance3D = MeshInstance3D.new()

		node_instances.add_child(minstance)
		minstance.set_owner(self.owner)
		minstance.transform = multimesh.get_instance_transform(index)
		minstance.mesh = multimesh.mesh

	# reset the mmesh - because it's all exploded now!
	multimesh.instance_count = 0 #resets the mutimesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D

	#multimesh.visible_instance_count=0 #hide the multimesh
	node_instances.visible = true


## IMPLODE - from instance (children) into the multimesh
## Proceeds as if we CAN implode - all failures checked before
## this is called.
func _implode():
	var mesh_children:Array = find_children("*", "MeshInstance3D", true)

	# Get the mesh from the first mi3d we encounter
	var themesh:Mesh = multimesh.mesh
	if not themesh:
		for m in mesh_children:
			if m.mesh:
				themesh = m.mesh
				break

	var child : Node3D
	var count : int = mesh_children.size()

	# reset the mmesh
	multimesh.instance_count = 0 #resets the mutimesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D

	# Now we begin the entire multimesh and build it
	multimesh.instance_count = count
	multimesh.mesh = themesh

	for index in range(0,count):
		child = mesh_children[index]
		var nt : Transform3D = Transform3D(
			child.transform.basis, child.position)

		multimesh.set_instance_transform(index,nt)

		# do away with the child
		child.visible = false
		child.queue_free()

	multimesh.visible_instance_count = count

	# get rid of the tmp node that explode makes.
	var dangle = get_node_or_null(_tmpNodeName)
	if dangle:
		dangle.queue_free()


const sbodname : String = "StaticBody3D"
func _make_colliders():
	if multimesh:
		if multimesh.mesh:
			var shape : Shape3D
			match shape_type:
				colliders.DIRTY_SIMPLE :
					shape = multimesh.mesh.create_convex_shape(false,true)
				colliders.DIRTY_NORMAL :
					shape = multimesh.mesh.create_convex_shape(false,false)
				colliders.CLEAN_SIMPLE :
					shape = multimesh.mesh.create_convex_shape(true,true)
				colliders.CLEAN_NORMAL :
					shape = multimesh.mesh.create_convex_shape(true,false)
				colliders.TRIMESH      :
					shape = multimesh.mesh.create_trimesh_shape()

			var sbod : StaticBody3D = get_node_or_null(sbodname)
			if sbod:
				remove_child(sbod)
				sbod.free()
			#make a new one
			sbod = StaticBody3D.new()
			sbod.name = sbodname
			add_child(sbod)
			sbod.set_owner(self.owner)
			for index in multimesh.instance_count:
				var coll:CollisionShape3D = CollisionShape3D.new()
				coll.shape = shape
				sbod.add_child(coll)
				coll.set_owner(self.owner)
				coll.transform = multimesh.get_instance_transform(index)

