class_name Enemy
extends Area2D

signal enemy_killed(points: int, death_sound: AudioStream, source: Node)
signal hit

@export var speed: int = 200
@export var hp: int = 2
@export var points: int = 10
@export var death_sound: AudioStream
@export var damage: int = 1

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func die(source: Node) -> void:
	enemy_killed.emit(points, death_sound, source)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage) #damages player
		take_damage(hp,body)

func take_damage(amount: int, source: Node) -> void:
	hp -= amount
	if hp <= 0:
		die(source)
	else:
		hit.emit()
