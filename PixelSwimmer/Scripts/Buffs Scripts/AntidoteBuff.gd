class_name AntidoteBuff
extends Buffs

@export var antidote_text_scene: PackedScene

func _on_body_entered(body):
	if body.is_in_group("player"):
		
		body.cure_poison()
		show_antidote_text(body)
		
		picked_up.emit(buff_sound)
		queue_free()

func show_antidote_text(player: Node) -> void:
	var popup = antidote_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
