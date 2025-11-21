class_name AntidoteBuff
extends Buffs

func _on_body_entered(body):
	if body is Player:
		
		body.cure_poison()
		
		picked_up.emit(buff_sound)
		queue_free()
