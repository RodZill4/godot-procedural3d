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
			#print("Trying "+r.name)
			if !r.get_exits(exit.exit_type, !exit.inbound).empty():
				#print("OK")
				room_candidates.append(r)
		if room_candidates.empty():
			print("Failed to find matching room")
			break
		var room = room_candidates[randi()%room_candidates.size()].duplicate()
		generated.add_child(room)
		room.set_owner(get_owner())
		var exit_candidates = room.get_exits(exit.exit_type, !exit.inbound)
		exit_candidates[randi()%exit_candidates.size()].join(exit)
		var keep = true
		if room.has_node("space"):
			var area1 = room.get_node("space")
			print("Testing collisions")
			yield(get_tree(), "idle_frame")
			print(area1.get_overlapping_areas())
			if !area1.get_overlapping_areas().empty():
				generated.remove_child(room)
				room.free()
				exits.append(exit)
				keep = false
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
	if exits.empty():
		print("No pending exit")
