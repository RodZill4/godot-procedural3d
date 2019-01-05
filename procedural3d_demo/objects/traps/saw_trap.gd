tool
extends StaticBody

export(int, 2, 10) var count_x = 1 setget set_count_x
export(int, 1, 10) var count_y = 1 setget set_count_y

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	do_update()
	var room = get_parent()
	room.connect("enter_room", self, "on_enter_room")
	room.connect("leave_room", self, "on_leave_room")

func do_update():
	if !is_inside_tree():
		return
	for c in get_children():
		if c is MeshInstance:
			c.queue_free()
	for c in $saws.get_children():
		c.queue_free()
	for y in range(count_y):
		# add saw size, time, start_pos
		var saw = preload("res://procedural3d_demo/objects/traps/saw.tscn").instance()
		$saws.add_child(saw)
		saw.init(count_x-2, 2, float(count_y-y)/count_y)
		saw.translation.z = y
		# add models for saw slot ends
		var mesh_instance = MeshInstance.new()
		mesh_instance.mesh = preload("res://procedural3d_demo/models/meshes/trap_floor_saw_slot_end.tres")
		mesh_instance.translation = Vector3(0, 0, y)
		add_child(mesh_instance)
		mesh_instance = MeshInstance.new()
		mesh_instance.mesh = preload("res://procedural3d_demo/models/meshes/trap_floor_saw_slot_end.tres")
		mesh_instance.translation = Vector3(count_x-1, 0, y)
		mesh_instance.rotation = Vector3(0, PI, 0)
		add_child(mesh_instance)
		# add models for saw slot ends
		for x in range(1, count_x-1):
			mesh_instance = MeshInstance.new()
			mesh_instance.mesh = preload("res://procedural3d_demo/models/meshes/saw_slot_mid.tres")
			mesh_instance.translation = Vector3(x, 0, y)
			add_child(mesh_instance)
	$CollisionShape.shape.extents.x = 0.5*count_x
	$CollisionShape.shape.extents.z = 0.5*count_y
	$CollisionShape.translation.x = 0.5*(count_x-1)
	$CollisionShape.translation.z = 0.5*(count_y-1)

func set_count_x(new_count_x):
	if new_count_x != count_x:
		count_x = new_count_x
		#do_update()

func set_count_y(new_count_y):
	if new_count_y != count_y:
		count_y = new_count_y
		#do_update()

func on_enter_room(body):
	for s in $saws.get_children():
		s.start()

func on_leave_room(body):
	for s in $saws.get_children():
		s.stop()
