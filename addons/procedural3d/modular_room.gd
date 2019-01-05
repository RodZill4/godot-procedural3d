tool
extends Spatial

export(int, 1, 10) var probability = 1

var model = null

const GENERATOR_SCRIPT = preload("res://addons/procedural3d/generator.gd")
const EXIT_SCRIPT = preload("res://addons/procedural3d/modular_room_exit.gd")
const OBJECT_SCRIPT = preload("res://addons/procedural3d/modular_room_object.gd")

signal enter_room(body)
signal leave_room(body)

func _ready():
	pass

func get_toolbar_buttons(tb = null):
	var buttons = []
	buttons.append({ label="Configure", function="generate" })
	return buttons

func duplicate():
	var rv = .duplicate(DUPLICATE_USE_INSTANCING)
	rv.model = name
	return rv

func get_all_exits():
	var exits = []
	for c in get_children():
		if c.get_script() == EXIT_SCRIPT:
			exits.append(c)
	return exits

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

func _on_enter_room(body):
	emit_signal("enter_room", body)

func _on_leave_room(body):
	emit_signal("leave_room", body)

