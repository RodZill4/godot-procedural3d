extends Spatial

func _ready():
	pass

func trigger():
	$AnimationPlayer.play("trigger")

func _on_Area_body_entered(body):
	if body.has_method("kill"):
		body.kill()