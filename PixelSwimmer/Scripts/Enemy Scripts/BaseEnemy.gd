class_name Enemy
extends Area2D

#signals
signal enemy_killed(points, death_sound, source)
signal hit
signal killed_by(source)

#variables
var is_dead: bool = false

@export var speed: int = 200
@export var hp: int = 2
@export var points: int = 10
@export var death_sound: AudioStream
@export var damage: int = 1

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func die(source: Node) -> void:
	enemy_killed.emit(points, death_sound, source)
	killed_by.emit(source)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage) #damages player
		take_damage(hp,body)

func take_damage(amount: int, source: Node = null) -> void: 
	if is_dead:
		return
		
	hp -= amount
	
	if hp <= 0:
		die(source)
	else:
		hit.emit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
