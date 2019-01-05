tool
extends Spatial

export(String) var object_type = null
var object = null

func _ready():
	pass

func generate(generator):
	var room = get_parent()
	#print("Choosing object for "+name)
	if object_type == null:
		return false
	if !generator.has_node("objects/"+object_type):
		return false
	var objects = generator.get_node("objects/"+object_type).get_children()
	if objects.empty():
		return false
	if object != null:
		room.remove_child(object)
		object.free()
	object = objects[randi()%objects.size()].duplicate(DUPLICATE_USE_INSTANCING)
	object.transform = transform
	room.add_child(object)
	object.set_owner(generator.get_owner())
