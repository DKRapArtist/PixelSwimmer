class_name BossMinion
extends Enemy

@export var laser_scene: PackedScene
@export var fire_interval := 1.5
@export var move_speed := 120.0

@onready var fire_timer = $FireTimer

var player: Node2D
var target_pos: Vector2

const MIN_X := 30.0
const MAX_X := 500.0
const MIN_Y := 600.0
const MAX_Y := 650.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	fire_timer.wait_time = fire_interval
	fire_timer.start()

	# Only pick a random wander target in story mode
	if GameSession.mode == "story":
		_pick_new_target()

func _physics_process(delta: float) -> void:
	if GameSession.mode == "story":
		_move_in_zone(delta)      # new behaviour
	else:
		_survival_movement(delta) # old behaviour

func _move_in_zone(delta: float) -> void:
	var dir := (target_pos - global_position)
	if dir.length() < 5.0:
		_pick_new_target()
		return

	dir = dir.normalized()
	global_position += dir * move_speed * delta

func _pick_new_target() -> void:
	var rand_x = randf_range(MIN_X, MAX_X)
	var rand_y = randf_range(MIN_Y, MAX_Y)
	target_pos = Vector2(rand_x, rand_y)

func _survival_movement(delta: float) -> void:
	global_position.y += speed * delta

func _on_fire_timer_timeout() -> void:
	if player == null or not is_instance_valid(player):
		return

	var laser = laser_scene.instantiate()
	var dir := (player.global_position - global_position).normalized()
	laser.global_position = global_position + dir * 50
	laser.direction = dir
	laser.original = self
	get_tree().current_scene.add_child(laser)
