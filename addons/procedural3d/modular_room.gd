tool
extends Spatial

const GENERATOR_SCRIPT = preload("res://addons/procedural3d/generator.gd")
const EXIT_SCRIPT = preload("res://addons/procedural3d/modular_room_exit.gd")
const OBJECT_SCRIPT = preload("res://addons/procedural3d/modular_room_object.gd")

func _ready():
	pass

func get_exits(type = null, inbound = false):
	var exits = []
	for c in get_children():
		if c.get_script() == EXIT_SCRIPT and c.connected_to == null:
			#print("Found exit "+c.name)
			if type == null or type == c.exit_type and inbound == c.inbound:
				exits.append(c)
	return exits

func has_connected_exits():
	for c in get_children():
		if c.get_script() == EXIT_SCRIPT and c.connected_to != null:
			return true
	return false

func generate(undo_redo):
	var generator = get_parent().get_parent()
	if generator.get_script() != GENERATOR_SCRIPT:
		return false
	for c in get_children():
		if c.get_script() == OBJECT_SCRIPT:
			c.generate(generator)
