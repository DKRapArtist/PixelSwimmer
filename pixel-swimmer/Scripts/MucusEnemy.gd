extends Enemy

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_slow(0.5, 10.0) #halves speed for 10 seconds
		body.take_damage(1)
		take_damage(hp, body)
