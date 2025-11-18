class_name Buffs
extends Area2D

#signals
signal picked_up

#export variables
@export var buff_speed: int = 200
@export var buff_type: = "heal"
@export var amount: = 1
#@export var duration: = 3.0

func _on_body_entered(body):
	if body is Player:
		if buff_type == "heal":
			body.heal(int(amount))
		picked_up.emit()
		queue_free()

func _physics_process(delta: float) -> void:
	global_position.y += buff_speed * delta
