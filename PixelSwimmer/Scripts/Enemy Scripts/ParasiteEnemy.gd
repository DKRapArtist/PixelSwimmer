extends Enemy

@export var heal_block_duration: float = 0.0
@export var poisoned_text_scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body is Player:

		# Damage player first
		body.take_damage(damage)
		body.apply_poison()
		show_poisoned_text(body)

		# Enemy kills itself on contact
		take_damage(hp, body)


func show_poisoned_text(player: Node) -> void:
	# Stop if shielded (extra safety)
	if player.has_shield:
		return

	var popup = poisoned_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO
	popup.show_text()
