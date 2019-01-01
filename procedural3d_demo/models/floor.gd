tool
extends StaticBody

export(int, 1, 10) var count_x = 1 setget set_count_x
export(int, 1, 10) var count_y = 1 setget set_count_y

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	do_update()

func do_update():
	for c in get_children():
		if c is MeshInstance:
			c.queue_free()
	for x in range(count_x):
		for y in range(count_y):
			var mesh_instance = MeshInstance.new()
			mesh_instance.mesh = preload("res://procedural3d_demo/models/meshes/struct_floor_normal.tres")
			mesh_instance.translation = Vector3(x, 0, y)
			add_child(mesh_instance)
	$CollisionShape.shape.extents.x = 0.5*count_x
	$CollisionShape.shape.extents.z = 0.5*count_y
	$CollisionShape.translation.x = 0.5*(count_x-1)
	$CollisionShape.translation.z = 0.5*(count_y-1)

func set_count_x(new_count_x):
	if new_count_x != count_x:
		count_x = new_count_x
		do_update()

func set_count_y(new_count_y):
	if new_count_y != count_y:
		count_y = new_count_y
		do_update()
