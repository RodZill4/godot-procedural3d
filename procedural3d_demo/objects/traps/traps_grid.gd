tool
extends Spatial

export(int, 1, 10) var count_x = 1 setget set_count_x
export(int, 1, 10) var count_y = 1 setget set_count_y

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	do_update()

func do_update():
	if !has_node("traps"):
		return
	for c in $traps.get_children():
		c.queue_free()
	for x in range(count_x):
		for y in range(count_y):
			var trap = preload("res://procedural3d_demo/objects/traps/spike_trap.tscn").instance()
			trap.translation = Vector3(x, 0, y)
			$traps.add_child(trap)
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

func _on_Timer_timeout():
	for t in $traps.get_children():
		t.trigger()
