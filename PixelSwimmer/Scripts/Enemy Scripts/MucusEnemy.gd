extends  Enemy

@export var mucus_text_scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_slow(0.5, 10.0) #halves speed for 10 seconds
		show_mucus_text(body)
		body.take_damage(1) 
		take_damage(hp,body)

func show_mucus_text(player: Node) -> void:
	var popup = mucus_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
