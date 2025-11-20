class_name Laser
extends Area2D

@export var speed = 600
@export var damage = 1
var original: Node = null
var direction: Vector2 = Vector2.UP

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == original:
		return

	if area is Enemy:
		if area.is_dead:
			queue_free()
			return

		var src := original
		if src != null and is_instance_valid(src):
			area.take_damage(damage, src)
		else:
			# call overload / default that doesn't need a source
			area.take_damage(damage)

		queue_free()
