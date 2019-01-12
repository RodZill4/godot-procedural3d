tool
extends Area

func get_toolbar_buttons(tb = null):
	var buttons = []
	buttons.append({ label="Test", function="test" })
	return buttons

func test():
	print(preload("res://addons/procedural3d/intersect_obb.gd").intersect($CollisionShape, $CollisionShape2))