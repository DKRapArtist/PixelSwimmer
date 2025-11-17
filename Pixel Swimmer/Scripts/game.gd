extends Node2D

#export variables
@export var enemy_scenes: Array[PackedScene] = []

#onready variables
@onready var player := $Player
@onready var hud := $UILayer/HUD
@onready var gos := $UILayer/GameOverScreen
@onready var pause_menu := $UILayer/PauseMenu
@onready var options_menu := $UILayer/PauseMenu/OptionsMenu
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var player_spawn := $PlayerSpawn
@onready var pb = $Parallax2D

# SFX
@onready var player_shooting_sound = $SFX/PlayerShooting
@onready var player_hit_sound = $SFX/PlayerHit
@onready var enemy_hit_sound = $SFX/EnemyHit
@onready var player_death_sound = $SFX/PlayerDeath
@onready var death_sfx_player: AudioStreamPlayer = $SFX/DeathSfxPlayer

#variables
const GAME_MUSIC := preload("res://Assets/Sound Design/Music/Pixel Swimmer Game Music.wav")
const GAME_OVER_MUSIC := preload("res://Assets/Sound Design/Music/Pixel Swimmer Game Over Music.wav")

#player score
var score := 0:
	set = set_score
	
func set_score(value):
	score = value
	hud.score = score

var high_score

#READY FUNCTION #run this code when the scene starts and everything is in place
func _ready() -> void:
	MenuMusic.play_menu_music(GAME_MUSIC)
	
	pause_menu.visible = false
	SettingsManager.load_settings()
	
	#recieves signals
	pause_menu.resume_pressed.connect(_resume_game)
	pause_menu.options_pressed.connect(_open_pause_options)
	pause_menu.options_back_pressed.connect(_pause_options_back)
	pause_menu.main_menu_pressed.connect(_go_to_main_menu)
	pause_menu.quit_pressed.connect(_quit_game)

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

#FUNCTIONS

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

#background movment speed
var scroll_speed = 300

# ------------------------------------------------------------
# PAUSE RESET — IMPORTANT
# ------------------------------------------------------------

func show_pause():
	visible = true
	pause_menu.visible = true
	options_menu.visible = false

func show_options():
	visible = true
	pause_menu.visible = false
	options_menu.visible = true

#WHAT HAPPENS WHEN YOU PAUSE THE GAME
func _pause_game():
	get_tree().paused = true
	pause_menu.show_pause()
	$UILayer/HUD.visible = false

#WHAT HAPPENS WHEN YOU RESUME THE GAME
func _resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	hud.visible = true

# ------------------------------------------------------------
# Pause Button on HUD
# ------------------------------------------------------------
func _open_pause_options() -> void:
	options_menu.open_from_pause()

func _pause_options_back():
	pause_menu.show_pause()

func _go_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _quit_game():
	get_tree().quit()

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

#background movement
	pb.scroll_offset.y += delta*scroll_speed
	if pb.scroll_offset.y >= 960:
		pb.scroll_offset.y = 0


	
# ------------------------------------------------------------
# ENEMY & LASER LOGIC
# ------------------------------------------------------------

func _on_player_laser_shot(laser_scene, location):
	var laser: Laser = laser_scene.instantiate()
	laser.global_position = location
	laser.original = laser         # set owner here
	laser_container.add_child(laser)
	player_shooting_sound.play()

func _on_enemy_spawn_timer_timeout() -> void:
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.enemy_killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)

func _on_enemy_killed(points, death_sound, source):
	if death_sound:
		death_sfx_player.stream = death_sound
		death_sfx_player.play()

	if is_instance_valid(source):
		# Only do checks or calls on source inside this block
		if source is Laser:
			score += points

	if score > high_score:
		high_score = score


func _on_enemy_hit():
	enemy_hit_sound.play()

func _on_player_killed():
	MenuMusic.play_game_over(GAME_OVER_MUSIC)
	player_death_sound.play()
	$UILayer/HUD/PauseButton.visible = false
	$UILayer/HUD.visible = false

	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()

	await get_tree().create_timer(0.5).timeout
	gos.visible = true
