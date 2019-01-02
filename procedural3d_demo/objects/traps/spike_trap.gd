extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func trigger():
	$AnimationPlayer.play("trigger")

func _on_Area_body_entered(body):
	if body.has_method("kill"):
		body.kill()