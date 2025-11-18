extends Enemy

#export variables
@export var heal_block_duration: float = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage) #damages player
		
		#disable healing
		body.can_heal = false
		
		take_damage(hp,body)
