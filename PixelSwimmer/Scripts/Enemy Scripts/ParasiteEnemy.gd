extends Enemy

#export variables
@export var heal_block_duration: float = 0.0
@export var poisoned_text_scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage) #damages player
		
		#disable healing
		body.apply_poison()
		show_poisoned_text(body)
		
		take_damage(hp,body)

func show_poisoned_text(player: Node) -> void:
	var popup = poisoned_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
