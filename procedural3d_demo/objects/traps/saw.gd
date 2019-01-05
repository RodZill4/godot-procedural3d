tool
extends Spatial

var start_time

func init(size, time, start_pos):
	$anim_saw_leftright.interpolate_property($saw_position, "translation", Vector3(-0.2, 0, 0), Vector3(size+0.2, 0, 0), time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$anim_saw_leftright.interpolate_property($saw_position, "translation", Vector3(size+0.2, 0, 0), Vector3(-0.2, 0, 0), time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, time)
	start_time = time * start_pos

func start():
	$anim_saw_updown.play("activate")
	$anim_saw_leftright.repeat = true
	$anim_saw_leftright.start()
	$anim_saw_leftright.seek(start_time)

func stop():
	$anim_saw_updown.play_backwards("activate")
	$anim_saw_leftright.repeat = false

func _on_saw_body_entered(body):
	if body.has_method("kill"):
		body.kill()