class_name BacteriaMinion
extends Area2D

#signals
signal enemy_killed(points, death_sound, source)

@export var death_sound: AudioStream
@export var damage: int = 1

func die(source: Node) -> void:
	enemy_killed.emit(death_sound, source)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage) #damages enemy

#deletes enemy when timer runs out
func _on_despawn_timer_timeout() -> void:
	queue_free()
