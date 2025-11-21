extends Enemy

@export var retaliate_damage := 3

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(retaliate_damage) # Corrected
		take_damage(hp, body)

func take_damage(amount: int, source: Node = null) -> void:
	# You can comment out retaliation here if you want it only on death
	# if source is Player:
	#     source.take_damage(retaliate_damage)
	super.take_damage(amount, source)

func die(source: Node) -> void:
	if is_dead:
		return
	is_dead = true

	# Only punish if the killer is the player
	if source is Player:
		source.take_damage(retaliate_damage) # Corrected

	var explosion = $ExplodingVFX
	explosion.emitting = true

	var sfx = $ExplosionSound
	sfx.play()

	explosion.reparent(get_tree().current_scene)

	await get_tree().create_timer(0.1).timeout

	enemy_killed.emit(points, death_sound, source)
	queue_free()
