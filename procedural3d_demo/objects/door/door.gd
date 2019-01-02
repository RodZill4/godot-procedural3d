extends StaticBody

var open = false

func has_nonstatic_overlapping_bodies(exited_body = null):
	for b in $detect_area.get_overlapping_bodies():
		if b != exited_body and !(b is StaticBody):
			print("found "+str(b))
			return true
	return false

func _on_detect_area_body_entered(body):
	print("_on_detect_area_body_entered")
	if has_nonstatic_overlapping_bodies():
		if !open:
			print("Opening door")
			$AnimationPlayer.play("open")
		$timer.stop()
		open = true

func _on_detect_area_body_exited(body):
	print("_on_detect_area_body_exited")
	if !has_nonstatic_overlapping_bodies(body):
		print("Waiting to close door")
		$timer.start()

func _on_timer_timeout():
	print("Closing door")
	$AnimationPlayer.play("open", -1, -1, true)
	open = false
