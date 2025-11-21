class_name MiniCells
extends Enemy

func die(source: Node) -> void:

	#emit signal, points, deathsound and remove enemy
	enemy_killed.emit(points, death_sound, source)
	queue_free()
