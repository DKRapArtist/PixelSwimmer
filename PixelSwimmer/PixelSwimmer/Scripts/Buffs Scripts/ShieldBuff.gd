class_name ShieldBuff
extends Buffs

@export var shield_text_scene: PackedScene

#variables
@export var duration = 10

func _on_body_entered(body):
	if body is Player:
		
		body.apply_shield(10.0)
		show_shield_text(body)
		
		picked_up.emit(buff_sound)
		queue_free()

func show_shield_text(player: Node) -> void:
	var popup = shield_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
