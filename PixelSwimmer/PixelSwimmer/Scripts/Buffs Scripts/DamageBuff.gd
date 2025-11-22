class_name DamageBuff
extends Buffs

@export var duration = 20
@export var damage_text_scene: PackedScene  # DamageX2Text.tscn

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.apply_damage_buff(20.0)
		show_damage_x2_text(body)
		picked_up.emit(buff_sound)
		queue_free()

func show_damage_x2_text(player: Node) -> void:
	var popup = damage_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
