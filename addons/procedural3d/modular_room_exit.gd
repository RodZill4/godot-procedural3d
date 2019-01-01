tool
extends Spatial

export(String) var exit_type
export(bool)   var inbound
var connected_to = null

func join(exit):
	var room = exit.get_parent()
	var room_self = get_parent()
	if exit.exit_type != exit_type or exit.inbound == inbound or connected_to != null or exit.connected_to != null or room == room_self:
		return false
	if get_parent().has_connected_exits():
		return false
	connected_to = exit
	exit.connected_to = self
	room_self.transform = room.transform*exit.transform*transform.affine_inverse()

func _exit_tree():
	if connected_to != null:
		connected_to.connected_to = null
		print("Exit deleted, disconnecting "+str(connected_to))
