extends Control


var IC_OtherAlreadyOpenMeta 	 = "FastTextICAlreadyOpen"			# true/false
var IC_OtherAlreadyOpenOwnerMeta = "FastTextICAlreadyOpenOwner"   # object
var MyOwner = null

func _ready():
    MyOwner=_get_other_IC_AlreadyOpen_Owner()
    pass

func _input(event):
    if MyOwner._IC_input(event):
        accept_event()



func _get_other_IC_AlreadyOpen_Owner():  # fromt FastText.gd
    if get_tree().has_meta(IC_OtherAlreadyOpenOwnerMeta):
        return get_tree().get_meta(IC_OtherAlreadyOpenOwnerMeta)
    return null
