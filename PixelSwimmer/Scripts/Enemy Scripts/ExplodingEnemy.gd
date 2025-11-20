extends Enemy

@export var retaliate_damage := 3

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(3) 
		take_damage(hp,body)

func take_damage(amount: int, source: Node) -> void:
	if source is Player:
		source.take_damage(retaliate_damage)

	super.take_damage(amount, source)

func die(source: Node) -> void:
	if is_dead:
		return
	is_dead = true
	
	var player := get_tree().current_scene.get_node("Player")
	if is_instance_valid(player):
		player.take_damage(retaliate_damage)

	var explosion := $ExplodingVFX
	explosion.emitting = true

	var sfx := $ExplosionSound
	sfx.play()

	explosion.reparent(get_tree().current_scene)

	await get_tree().create_timer(0.1).timeout

	enemy_killed.emit(points, death_sound, source)
	queue_free()
