tool
extends MeshInstance
onready var dummy_cam = $DummyCam
onready var mirror_cam = $View/Camera
var a = {}	#dictionary to remember Meshinstances' cull masks
export(int, 1, 20, 1) var IgnoreLayer = 2
#For Diagnostics:=========================================================================================================================================================================================================================================
#var BDY
#var Clmsk
#=========================================================================================================================================================================================================================================================


func _ready():
#	print(find_node("Camera").get("cull_mask"))
	add_to_group("mirrors")	
	get("material/0").get("shader_param/refl_tx").set("viewport_path",find_node("View").get_path())			#sets the viewport_path to the right viewport for every instance of this scene ,Mi2's child(0)='View'
	$View.size = Vector2(2000,1000)			#the screen display size (from project settings)
											# must have the same width to height ratio (w=2h) as the settings here: 
	#$View.size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	get_node("View/Camera").set("cull_mask",1048575)#when all the camera's layer bits are turned on, the cull mask value is 1048575:  2^0 + 2^1 + 2^2 +...+2^19=1048575
	get_node("View/Camera").set_cull_mask_bit(IgnoreLayer-1,false)		#while every layer is on this turns the chosen layer off
#For Diagnostics:=========================================================================================================================================================================================================================================
#	Clmsk=(log(1048575-get_node("View/Camera").get("cull_mask"))/log(2)+1)		#The cameras' cull mask layer (clmsk) = log2(1048575-Cull_mask_Value)+1
#=========================================================================================================================================================================================================================================================
	
	
	
#The player's camera node calls this function to update the mirror-cameras position
#shout out to Miziziziz who came up with this: https://www.youtube.com/watch?v=xXUVP6sN-tQ
func update_cam(main_cam_transform):
	scale.y *= -1
	dummy_cam.global_transform = main_cam_transform
	scale.y *= -1
	mirror_cam.global_transform = dummy_cam.global_transform
	mirror_cam.global_transform.basis.x *= -1


#recursively goes through a PhysicsBody node's branch to remember MeshInstances' layer mask 
#as it replaces it with the layer mask that the mirror's camera ignores
func _remember_MeshInstances(N):
	if(N != null):
#For Diagnostics:=========================================================================================================================================================================================================================================
#		print(N.name)
#==========================================================================================================================================================================================================================================================
		if((N.is_class("MeshInstance"))&&(!a.has(N))):		#it checks if a MeshInstance it finds in the entering body is not yet added in the dictionary
#For Diagnostics:==========================================================================================================================================================================================================================================
#			print("\n","Before Entering, \"",N.name,"\", from node: \"",BDY,"\", had a layer mask value of: ",N.get_layer_mask())		#shows the meshInstance's name, which physicsBody it belongs to and it's CullMask value before entering the HideArea
#==========================================================================================================================================================================================================================================================
			a[N]=N.get_layer_mask()			#Stores MeshInstances in dictionary a
			N.set_layer_mask(0)		#Sets layer Mask bits to be all false except for the chosen layer
			N.set_layer_mask_bit(IgnoreLayer-1,true)	#the layer mask bits are just 1 less than the actual layers
#For Diagnostics:==========================================================================================================================================================================================================================================
#			print("\n","While Inside, \"",N.name,"\", from node: \"",BDY,"\", is set to appear only in layer: ",(log(N.get_layer_mask())/log(2)+1))			#shows the meshInstance's name, which physicsBody it belongs to and it's new CullMask value
#			print("This Mirror's cull mask is set to ignore layer: ",Clmsk)		# mirrors ignored cull mask layer
#			if((N.get_layer_mask()+get_node("View/Camera").get("cull_mask")==1048575)):		#the camera's layers are all ON except for the chosen layer to be ignored, the mesh's layers are all OFF except for the chosen layer so it could get ignored
#				print("The mirror is correctly ignoring this body when it passed behind it")#if they were missaligned in any way
#			else:
#				print("I don't know what but something definitely went wrong")
#==========================================================================================================================================================================================================================================================
		if(N.get_child_count()!=0):		#checks if the node still has children that the code has to sift thru
			for i in N.get_child_count():
				_remember_MeshInstances(N.get_child(i))		#recursion
#For Diagnostics:==========================================================================================================================================================================================================================================
#		else:							#shows up at the leaf(end) nodes
#			print("=================")
#==========================================================================================================================================================================================================================================================



#Goes thru the exiting body's stuff and restores each MeshInstancs' original layer mask
func _restore_Mesh_mask(N):
	if(N != null):
#For Diagnostics:==========================================================================================================================================================================================================================================
#		print(N.name)
#==========================================================================================================================================================================================================================================================
		if((N.is_class("MeshInstance"))&&(a.has(N))):		#checks if the MeshInstance has a saved layer mask in the dictionary
#For Diagnostics:==========================================================================================================================================================================================================================================
#			print("\n","Before Exiting, \"",N.name,"\", from node: \"",BDY,"\", had a layer mask value of: ",N.get_layer_mask())		#shows the meshInstance's name, which physicsBody it belongs to and it's CullMask value before it exits the HideArea
#==========================================================================================================================================================================================================================================================
			N.set_layer_mask(a.get(N))		#If it does it checks out of the HideArea with it
#For Diagnostics:==========================================================================================================================================================================================================================================
#			print("\n","After Exiting, \"",N.name,"\", from node: \"",BDY,"\", has a layer mask value of: ",N.get_layer_mask())		#shows the meshInstance's name, which physicsBody it belongs to and it's CullMask value after it exits the HideArea
#==========================================================================================================================================================================================================================================================
			a.erase(N)		#the saved layer mask is then erased from the dictionary
		if(N.get_child_count()!=0):		#checks if the node still has children that the code has to go thru
			for i in N.get_child_count():
				_restore_Mesh_mask(N.get_child(i))		#recursion



#Sets the PhysicsBody to a layer mask that the mirror's camera ignores
func _on_HideArea_body_entered(body):
#For Diagnostics:==========================================================================================================================================================================================================================================
#	BDY=body.name			#saves the PhysicsBody being refered to, as the parent node
#==========================================================================================================================================================================================================================================================
	_remember_MeshInstances(body)
#For Diagnostics:==========================================================================================================================================================================================================================================
#	print("\nNodes currently in dictionary 'a':\n",a.keys())			#printsout the MeshInstances that the dictionary remembers at the moment
#	print("\nTheir Cull Mask Values:\n",a.values())		#printsout the Cull Mask values of said MeshInstances
#==========================================================================================================================================================================================================================================================



#puts the original cullmask value back after body exits the hide area
func _on_HideArea_body_exited(body):
#For Diagnostics:==========================================================================================================================================================================================================================================
#	BDY=body.name			#saves the PhysicsBody being refered to, as the parent node
#==========================================================================================================================================================================================================================================================
	_restore_Mesh_mask(body)
#For Diagnostics:==========================================================================================================================================================================================================================================
#	print("\nNodes currently in dictionary 'a':\n",a.keys())			#printsout the MeshInstances that the dictionary remembers at the moment
#	print("\nTheir Cull Mask Values:\n",a.values())		#printsout the Cull Mask values of said MeshInstances
#=========================================================================================================================================================================================================================================================
