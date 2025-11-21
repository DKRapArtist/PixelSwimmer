class_name BacteriaBuff
extends Buffs

signal bacteria_minion_requested

var minion_scene := preload("res://Scenes/Buffs Scenes/BacteriaMinion.tscn")
@export var minion_text_scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		picked_up.emit(buff_sound)
		show_minion_text(body)
		bacteria_minion_requested.emit()
		queue_free()  # only free yourself, no spawning here")


func _spawn_minion_and_free() -> void:
	# Get MinionSpawnPoint from THIS buff scene
	var spawn_point := $MinionSpawnPoint

	# Spawn minion
	var minion := minion_scene.instantiate()
	minion.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(minion)

	# Now safe to remove the buff
	queue_free()

func show_minion_text(player: Node) -> void:
	var popup = minion_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
