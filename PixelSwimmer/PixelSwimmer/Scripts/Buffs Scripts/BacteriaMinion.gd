class_name BacteriaMinion
extends Area2D

#signals
signal enemy_killed(points, death_sound, source)

@export var death_sound: AudioStream
@export var damage: int = 1
@export var minion_laser_scene: PackedScene
@export var fire_interval: float = 0.5
@export var move_speed: float = 100.0
var move_direction: int = 1  # 1 = right, -1 = left
const SCREEN_SIZE: Vector2 = Vector2(540, 960)
const MARGIN: float = 30.0
var owner_player: Player = null

@onready var fire_timer = $FireTimer
@onready var muzzle: Marker2D = $Muzzle
@onready var sfx_shoot: AudioStreamPlayer2D = $Sfx

func _ready() -> void:
	fire_timer.wait_time = fire_interval
	fire_timer.start()

func shoot() -> void:
	if minion_laser_scene == null:
		return
	var laser: Laser = minion_laser_scene.instantiate()
	get_tree().current_scene.add_child(laser)
	laser.global_position = muzzle.global_position
	laser.original = self
	laser.direction = Vector2.UP

	if sfx_shoot:
		sfx_shoot.play()
	
func die(source: Node) -> void:
	enemy_killed.emit(death_sound, source)
	queue_free()

#deletes enemy when timer runs out
func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_fire_timer_timeout() -> void:
	shoot()

func _physics_process(delta: float) -> void:
	# Move horizontally
	position.x += move_direction * move_speed * delta

	# Clamp inside screen with 30px margin
	var min_x := MARGIN
	var max_x := SCREEN_SIZE.x - MARGIN
	position.x = clamp(position.x, min_x, max_x)

	# Flip direction when hitting bounds
	if position.x <= min_x:
		move_direction = 1
	elif position.x >= max_x:
		move_direction = -1
