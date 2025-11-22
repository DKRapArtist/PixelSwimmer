class_name WhiteCell
extends Enemy

@export var mini_enemy_scene: PackedScene
@export var spawn_count := 3
@export var min_spawn_dist := 40.0
@export var max_spawn_dist := 80.0

func die(source: Node) -> void:
	var game := get_tree().current_scene  # or whatever node handles score/sound
	
	# spawn smaller enemies
	for i in range(spawn_count):
		var mini_cells: MiniCells = mini_enemy_scene.instantiate()

		var angle := randf_range(0.0, TAU)
		var distance := randf_range(min_spawn_dist, max_spawn_dist)
		var offset := Vector2(cos(angle), sin(angle)) * distance
		mini_cells.position = position + offset

		# connect mini’s death signal
		mini_cells.enemy_killed.connect(game._on_enemy_killed)

		game.call_deferred("add_child", mini_cells)

	# big white cell’s own death
	enemy_killed.emit(points, death_sound, source)
	call_deferred("queue_free")
