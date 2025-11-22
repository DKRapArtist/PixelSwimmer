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
		# If enemy is already dead, just remove the laser
		if area.is_dead:
			queue_free()
			return

		# Otherwise do damage, then remove the laser
		var src = original if is_instance_valid(original) else null
		area.take_damage(damage, src)
		queue_free()
