extends StaticBody

var open = false

func has_nonstatic_overlapping_bodies(exited_body = null):
	for b in $detect_area.get_overlapping_bodies():
		if b != exited_body and !(b is StaticBody):
			return true
	return false

func _on_detect_area_body_entered(body):
	if has_nonstatic_overlapping_bodies():
		if !open:
			$sound.play()
			$AnimationPlayer.play("open")
		$timer.stop()
		open = true

func _on_detect_area_body_exited(body):
	if !(body is StaticBody) and !has_nonstatic_overlapping_bodies(body):
		$timer.start()

func _on_timer_timeout():
	$AnimationPlayer.play_backwards("open")
	$sound.play()
	open = false
