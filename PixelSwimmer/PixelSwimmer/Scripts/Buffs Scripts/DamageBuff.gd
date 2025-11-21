class_name DamageBuff
extends Buffs

@export var duration = 20

func _on_body_entered(body):
	if body is Player:
		
		body.apply_damage_buff(20.0)
		
		picked_up.emit(buff_sound)
		queue_free()
