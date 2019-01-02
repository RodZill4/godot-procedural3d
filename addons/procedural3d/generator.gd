tool
extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func clean():
	if has_node("generated"):
		get_node("generated").queue_free()

func generate(undo_redo = null):
	print("Generating...")
	PhysicsServer.set_active(true)
	if undo_redo != null:
		undo_redo.create_action("Generate 3d scene from modular subscenes")
	var rooms = $rooms.get_children()
	var generated
	var exits
	if has_node("generated"):
		generated = get_node("generated")
		exits = []
		for c in generated.get_children():
			for e in c.get_exits():
				exits.append(e)
	else:
		generated = Spatial.new()
		generated.name = "generated"
		add_child(generated)
		generated.set_owner(get_owner())
		var room
		if $rooms.has_node("room_start"):
			room = $rooms.get_node("room_start").duplicate()
		else:
			room = rooms[randi()%rooms.size()].duplicate()
		room.translation = Vector3(0, 0, 0)
		generated.add_child(room)
		room.set_owner(get_owner())
		room.generate(self)
		room.set_display_folded(true)
		exits = room.get_exits()
	var count = 0
	while !exits.empty():
		var exit = exits.pop_front()
		#print("Trying to match exit "+exit.name+" of room "+exit.get_parent().name)
		var room_candidates = []
		for r in rooms:
			var possible_exits = r.get_exits(exit.exit_type, !exit.inbound)
			var allowed_exits = []
			for e in possible_exits:
				if !exit.is_forbidden(r.name, e.name):
					allowed_exits.append(e)
			if !allowed_exits.empty():
				for i in range(r.probability):
					room_candidates.append(r)
		if room_candidates.empty():
			var incorrect_room = exit.get_parent()
			print("Failed to find matching room for "+incorrect_room.model)
			var all_exits = incorrect_room.get_all_exits()
			if all_exits.size() == 2:
				for e in all_exits:
					if e != exit:
						e.connected_to.forbidden_connections.append({ room=incorrect_room.model, exit=e.name })
						exits.append(e)
				remove_child(incorrect_room)
				incorrect_room.free()
			else:
				print("Cannot fix room "+incorrect_room.name)
			continue
		var room = room_candidates[randi()%room_candidates.size()]
		var room_name = room.name
		room = room.duplicate()
		generated.add_child(room)
		room.set_owner(get_owner())
		var possible_exits = room.get_exits(exit.exit_type, !exit.inbound)
		var allowed_exits = []
		for e in possible_exits:
			if !exit.is_forbidden(room_name, e.name):
				allowed_exits.append(e)
		var selected_exit = allowed_exits[randi()%allowed_exits.size()]
		var selected_exit_name = selected_exit.name
		selected_exit.join(exit)
		var keep = true
		if room.has_node("space"):
			var area1 = room.get_node("space")
			yield(get_tree(), "physics_frame")
			yield(get_tree(), "physics_frame")
			yield(get_tree(), "physics_frame")
			if !area1.get_overlapping_areas().empty():
				generated.remove_child(room)
				room.free()
				exits.append(exit)
				keep = false
				exit.forbidden_connections.append({ room=room_name, exit=selected_exit_name })
		if keep:
			for e in room.get_exits():
				exits.append(e)
			room.generate(undo_redo)
			room.set_display_folded(true)
			if undo_redo != null:
				undo_redo.add_undo_method(room, "queue_free")
		count += 1
		if count > 20:
			break
	if undo_redo != null:
		undo_redo.commit_action()
	PhysicsServer.set_active(false)
	print(str(exits.size())+" pending exits")
