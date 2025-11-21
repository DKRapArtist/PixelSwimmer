class_name ShieldBuff
extends Buffs

#variables
@export var duration = 10

func _on_body_entered(body):
	if body is Player:
		
		body.apply_shield(10.0)
		
		picked_up.emit(buff_sound)
		queue_free()
