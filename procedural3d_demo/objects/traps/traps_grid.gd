tool
extends Spatial

export(PackedScene) var trap_scene = null
export(int, 1, 10)  var count_x = 1 setget set_count_x
export(int, 1, 10)  var count_y = 1 setget set_count_y

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	do_update()
	var room = get_parent()
	room.connect("enter_room", self, "on_enter_room")
	room.connect("leave_room", self, "on_leave_room")

func do_update():
	if !has_node("traps"):
		return
	for c in $traps.get_children():
		c.queue_free()
	for x in range(count_x):
		for y in range(count_y):
			var trap = trap_scene.instance()
			trap.translation = Vector3(x, 0, y)
			$traps.add_child(trap)
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

func trigger():
	for t in $traps.get_children():
		t.trigger()

func _on_Timer_timeout():
	trigger()

func on_enter_room(body):
	trigger()
	$Timer.start()

func on_leave_room(body):
	$Timer.stop()
