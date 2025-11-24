class_name Boss
extends Enemy

#signals
signal boss_died
signal spawn_minions(count: int)
signal shield_changed(active: bool)

#export variables
@export var laser_scene: PackedScene
@export var fire_interval := 1.5

#onready variables
@onready var fire_timer = $FireTimer
@onready var shield_particles = $ShieldCanvas/ShieldParticles
@onready var health_bar = $HealthBarCanvas/HealthBar

#variables
var player: Node2D
var max_hp = 200
var shield_active = false
var phase_thresholds = [150, 100, 50, 1]
var next_phase_index = 0
var pending_minions = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	fire_timer.wait_time = fire_interval
	fire_timer.start()
	shield_particles.visible = false  # start hidden
	
	#health bar
	health_bar.max_value = max_hp
	health_bar.value = hp
	
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

func die(source: Node = null):
	is_dead = true
	boss_died.emit()
	enemy_killed.emit(points, death_sound, source)
	queue_free()

func take_damage(amount: int, source: Node = null) -> void:
	if shield_active:
		return
	if is_dead:
		return
		
	hp -= amount
	
	#update healthbar
	health_bar.value = hp
	
	if hp <= 0:
		die(source)
	else:
		hit.emit()
		_check_phase_trigger()

func _check_phase_trigger() -> void:
	if next_phase_index >= phase_thresholds.size():
		return
	var threshold = phase_thresholds[next_phase_index]
	if hp <= threshold:
		_start_phase()

func _start_phase() -> void:
	shield_active = true
	shield_particles.visible = true
	shield_changed.emit(true)
	
	var minion_count := 3  # or vary by phase / threshold if you want
	pending_minions = minion_count
	spawn_minions.emit(minion_count)
	next_phase_index += 1

func on_minion_died() -> void:
	if pending_minions > 0:
		pending_minions -= 1

	if pending_minions <= 0 and shield_active:
		shield_active = false
		shield_particles.visible = false
		shield_changed.emit(false)

func _physics_process(_delta: float) -> void:
	pass

func _process(_delta):
	var screen_pos = get_viewport().get_camera_2d().unproject_position(global_position)
	health_bar.position = screen_pos + Vector2(0, -50)
