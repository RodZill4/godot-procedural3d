extends Spatial

func _ready():
	var room = get_parent()
	room.connect("enter_room", self, "on_enter_room")
	room.connect("leave_room", self, "on_leave_room")

func on_enter_room(body):
	$Particles.emitting = true
	$OmniLight.visible = true

func on_leave_room(body):
	$Particles.emitting = false
	$OmniLight.visible = false