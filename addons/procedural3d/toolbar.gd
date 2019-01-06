tool
extends HBoxContainer

var edited_object = null

var joined_room = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func edit_object(o):
	edited_object = o
	update_buttons()

func update_buttons():
	if edited_object is MeshInstance:
		for c in edited_object.get_children():
			if c is MeshInstance and c.visible:
				$Merge.visible = true
				break
	$JoinRooms.visible = false
	if edited_object is Spatial and edited_object.has_method("get_exits"):
		$JoinRooms.visible = true
		if joined_room == null:
			$JoinRooms.text = "Join"
		elif edited_object == joined_room:
			$JoinRooms.text = "Cancel join "+joined_room.name
		else:
			$JoinRooms.text = "Join "+joined_room.name+" to "+edited_object.name
	# Scene type specific buttons
	$VSeparator.visible = false
	for b in $SceneButtons.get_children():
		b.queue_free()
	if edited_object.has_method("get_toolbar_buttons"):
		for b in edited_object.get_toolbar_buttons(self):
			var button = Button.new()
			button.text = b.label
			button.disabled =  b.has("disabled") and b.disabled == true
			$SceneButtons.add_child(button)
			button.connect("pressed", self, "on_SceneButton_pressed", [ b.function ])
			$VSeparator.visible = true

func _on_MergeMeshes_pressed():
	if edited_object is MeshInstance:
		edited_object.mesh = edited_object.mesh.duplicate()
		for c in edited_object.get_children():
			if c is MeshInstance and c.visible:
				c.visible = false
				for i in range(c.mesh.get_surface_count()):
					var primitive = c.mesh.surface_get_primitive_type(i)
					var arrays = c.mesh.surface_get_arrays(i)
					var t = c.translation
					if t != Vector3(0, 0, 0):
						for j in arrays[0].size():
							arrays[0][j] += t
					edited_object.mesh.add_surface_from_arrays(primitive, arrays)
					edited_object.mesh.surface_set_material(edited_object.mesh.get_surface_count()-1, c.mesh.surface_get_material(i))

func join_rooms(r1, r2):
	if r1.get_parent() != r2.get_parent():
		print("Cannot join rooms that do not have the same parent")
		return
	print("Joining "+r1.name+" to "+r2.name)
	for r in [r1, r2]:
		print("  Exits of "+r.name)
		for e in r.get_exits():
			print("  - "+e.name+": "+str(e.get_global_transform().origin))
	var exit1 = null
	var exit2 = null
	var best_distance = 50
	for e1 in r1.get_exits():
		for e2 in r2.get_exits(e1.exit_type, !e1.inbound):
			var distance = (e1.get_global_transform().origin - e2.get_global_transform().origin).length()
			if distance < best_distance:
				best_distance = distance
				exit1 = e1
				exit2 = e2
	if exit1 != null and exit2 != null:
		print("Joining "+exit1.get_parent().name+"."+exit1.name+" to "+exit2.get_parent().name+"."+exit2.name)
		exit1.join(exit2)

func _on_JoinRooms_pressed():
	if joined_room == null:
		joined_room = edited_object
	elif joined_room == edited_object:
		joined_room = null
	else:
		join_rooms(joined_room, edited_object)
		joined_room = null
	update_buttons()

func _on_Clean_pressed():
	edited_object.clean()

func _on_Generate_pressed():
	edited_object.generate()

func on_SceneButton_pressed(function):
	edited_object.call(function)
	update_buttons()
