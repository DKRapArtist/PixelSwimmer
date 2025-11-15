extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var player = $Player
@onready var player_spawn := $PlayerSpawn
@onready var hud = $UILayer/HUD
@onready var pb = $Parallax2D
@onready var gos = $UILayer/GameOverScreen
@onready var pause_menu := $PauseMenu
@onready var options_menu := $PauseMenu/OptionsMenu
@onready var pause_panel := $PauseMenu/Pause

#SoundEffects
@onready var player_shooting_sound = $SFX/PlayerShooting
@onready var player_hit_sound = $SFX/PlayerHit
@onready var enemy_hit_sound = $SFX/EnemyHit
@onready var player_death_sound = $SFX/PlayerDeath
@onready var death_sfx_player: AudioStreamPlayer = $SFX/DeathSfxPlayer

var score := 0:
	set = set_score

func set_score(value):
	score = value
	hud.score = score

var high_score

#background movement speed
var scroll_speed = 300

# ------------------------------------------------------------
# PAUSE RESET — IMPORTANT
# ------------------------------------------------------------
func reset_pause_menu():
	pause_panel.visible = true
	options_menu.visible = false

# ------------------------------------------------------------

func _pause_game():
	get_tree().paused = true
	reset_pause_menu()
	pause_menu.visible = true
	hud.visible = false

func _resume_game():
	get_tree().paused = false
	reset_pause_menu()
	pause_menu.visible = false
	hud.visible = true

# ------------------------------------------------------------
# Pause Button on HUD
# ------------------------------------------------------------
func _on_pause_button_pressed() -> void:
	_pause_game()

# ------------------------------------------------------------
# Main Game Logic
# ------------------------------------------------------------
func _process(delta: float) -> void:

	if timer.wait_time > 0.5:
		timer.wait_time -= delta*0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5

	pb.scroll_offset.y += delta*scroll_speed
	if pb.scroll_offset.y >= 960:
		pb.scroll_offset.y = 0

func _ready() -> void:
	pause_menu.visible = false
	options_menu.visible = false
	reset_pause_menu()

	player.global_position = player_spawn.global_position

	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()

	score = 0
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

# ------------------------------------------------------------
# ENEMY & LASER LOGIC
# ------------------------------------------------------------
func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	player_shooting_sound.play()

func _on_enemy_spawn_timer_timeout() -> void:
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.enemy_killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)

func _on_enemy_killed(points, death_sound: AudioStream, source: Node) -> void:
	if death_sound:
		death_sfx_player.stream = death_sound
		death_sfx_player.play()

	if source is Laser:
		score += points
	if score > high_score:
		high_score = score

func _on_enemy_hit():
	enemy_hit_sound.play()

func _on_player_killed():
	$InGameMusic.stop()
	$GameOverMusic.play()
	player_death_sound.play()

	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()

	await get_tree().create_timer(0.5).timeout
	gos.visible = true
