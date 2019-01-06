tool
extends EditorPlugin

var toolbar = null

func _enter_tree():
	reload_toolbar()

func _exit_tree():
	remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, toolbar)
	toolbar = null

func reload_toolbar():
	if toolbar != null:
		remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, toolbar)
	toolbar = load("res://addons/procedural3d/toolbar.tscn").instance()
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, toolbar)

func _get_state():
	var s = {}
	return s

func _set_state(s):
	pass

func handles(o):
	print(o)
	return true

func edit(o):
	toolbar.edit_object(o)
