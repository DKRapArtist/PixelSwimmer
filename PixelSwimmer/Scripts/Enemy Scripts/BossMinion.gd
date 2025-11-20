class_name BossMinion
extends Enemy

@export var laser_scene: PackedScene
@export var fire_interval := 1.5
@onready var fire_timer = $FireTimer

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	# Timer already connected in editor (NO extra connect)
	fire_timer.wait_time = fire_interval
	fire_timer.start()

func _on_fire_timer_timeout() -> void:
	if player == null or not is_instance_valid(player):
		return

	var laser = laser_scene.instantiate()

	var dir := (player.global_position - global_position).normalized()

	# Spawn slightly ahead so it doesn’t hit itself
	laser.global_position = global_position + dir * 50
	laser.direction = dir
	laser.original = self

	get_tree().current_scene.add_child(laser)
