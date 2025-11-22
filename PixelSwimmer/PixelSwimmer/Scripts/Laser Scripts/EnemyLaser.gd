class_name EnemyLaser
extends Laser

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage) #damages player

		#delete player
		queue_free()
