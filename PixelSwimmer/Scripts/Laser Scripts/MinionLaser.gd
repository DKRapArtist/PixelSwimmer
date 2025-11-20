class_name MinionLaser
extends Laser

func _on_area_entered(area: Area2D) -> void:
	if area == original:
		return

	if area is Enemy:
		if area.is_dead:
			queue_free()
			return

		var src = original if is_instance_valid(original) else null
		area.take_damage(damage, src)
		queue_free()
