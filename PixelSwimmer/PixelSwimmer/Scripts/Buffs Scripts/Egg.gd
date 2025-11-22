class_name Egg
extends Buffs

@export var levelcompleted_text_scene: PackedScene

func _on_body_entered(body):
	if body.is_in_group("player"):
		
		body.level_completed()
		show_levelcompleted_text(body)
		
		picked_up.emit(buff_sound)
		queue_free()

func show_levelcompleted_text(player: Node) -> void:
	var popup = levelcompleted_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
