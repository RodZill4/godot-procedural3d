tool
extends StaticBody

export(int, 1, 10) var count_x = 1 setget set_count_x

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	do_update()

func do_update():
	for c in get_children():
		if c is MeshInstance:
			c.queue_free()
	for x in range(count_x):
			var mesh_instance = MeshInstance.new()
			mesh_instance.mesh = preload("res://procedural3d_demo/models/meshes/wall.tres")
			mesh_instance.translation = Vector3(x, 0, 0)
			add_child(mesh_instance)
	$CollisionShape.shape.extents.x = 0.5*count_x
	$CollisionShape.translation.x = 0.5*(count_x-1)

func set_count_x(new_count_x):
	if new_count_x != count_x:
		count_x = new_count_x
		do_update()
