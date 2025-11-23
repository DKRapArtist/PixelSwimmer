extends Node2D

#export variables
@export var bacteria_minion_scene: PackedScene
@export var boss_minion_scene: PackedScene

#onready variables
@onready var player := $Player
@onready var hud := $UILayer/HUD
@onready var gos := $UILayer/GameOverScreen
@onready var pause_menu := $UILayer/PauseMenu
@onready var options_menu := $UILayer/PauseMenu/OptionsMenu
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
@onready var buff_container = $BuffContainer
@onready var timer = $EnemySpawnTimer
@onready var story_enemy_spawn_timer: Timer = $StoryEnemySpawnTimer
@onready var buff_timer = $BuffSpawnTimer
@onready var player_spawn := $PlayerSpawn
@onready var minion_spawn := $MinionSpawnPoint
@onready var pb = $Parallax2D
@onready var level_completed_screen: Node2D = $UILayer/LevelCompletedScreen

# SFX
@onready var player_shooting_sound = $SFX/PlayerShooting
@onready var player_hit_sound = $SFX/PlayerHit
@onready var enemy_hit_sound = $SFX/EnemyHit
@onready var boss_hit_sound = $SFX/BossHit
@onready var player_death_sound = $SFX/PlayerDeath
@onready var buff_sfx_player: AudioStreamPlayer = $SFX/BuffSfxPlayer
@onready var death_sfx_player: AudioStreamPlayer = $SFX/DeathSfxPlayer

#variables
var enemy_scenes: Array[PackedScene] = []
var all_enemy_scenes: Array[PackedScene] = [
		preload("res://Scenes/Enemy Scenes/EnemySperm.tscn"), 
		preload("res://Scenes/Enemy Scenes/RedCell.tscn"),          #250
		preload("res://Scenes/Enemy Scenes/MucusEnemy.tscn"),       #500
		preload("res://Scenes/Enemy Scenes/ExplodingEnemy.tscn"),   #750
		preload("res://Scenes/Enemy Scenes/WhiteCell.tscn"),       #1000
		preload("res://Scenes/Enemy Scenes/Parasite.tscn"),        #1500
		preload("res://Scenes/Enemy Scenes/BossMinion.tscn")       #2000
]
var buff_scenes: Array[PackedScene] = []
var all_buff_scenes: Array[PackedScene] = [
	preload("res://Scenes/Buffs Scenes/BaseBuff.tscn"),
	preload("res://Scenes/Buffs Scenes/ShieldBuff.tscn"),
	preload("res://Scenes/Buffs Scenes/BacteriaBuff.tscn"),
	preload("res://Scenes/Buffs Scenes/DamageBuff.tscn"),
	preload("res://Scenes/Buffs Scenes/AntidoteBuff.tscn")
]
var levels = [
	{"EnemySperm":15, "RedCell": 15, "Egg": 1}, #Level 1
	{"EnemySperm":15, "RedCell": 15, "MucusEnemy": 5, "Egg": 1}, #Level 2
	{"EnemySperm":15, "RedCell": 15, "MucusEnemy": 5, "ExplodingEnemy": 5, "Egg": 1}, #Level 3
	{"EnemySperm":5, "RedCell": 5, "MucusEnemy": 10, "ExplodingEnemy": 7, "Egg": 1}, #Level 4
	{"EnemySperm":5, "RedCell": 2, "MucusEnemy": 5, "ExplodingEnemy": 10, "WhiteCell": 5, "Egg": 1}, #Level 5
	{"EnemySperm":5, "MucusEnemy": 10, "ExplodingEnemy": 10, "WhiteCell": 10, "Egg": 1}, #Level 6
	{"EnemySperm":5, "MucusEnemy": 5, "ExplodingEnemy": 10, "WhiteCell": 5, "Parasite": 5, "Egg": 1}, #Level 7
	{"EnemySperm":5, "MucusEnemy": 3, "ExplodingEnemy": 10, "WhiteCell": 10, "Parasite": 10, "BossMinion": 2, "Egg": 1}, #Level 8
	{"EnemySperm":5, "MucusEnemy": 1, "ExplodingEnemy": 10, "WhiteCell": 10, "Parasite": 10, "BossMinion": 5, "Egg": 1}, #Level 9
	{"Boss": 1,"Egg": 1} #BossLevel
]
var enemy_spawn_queue = []
var enemy_queue_index = 0
var minion: Node = null  # track current minion instance
const GAME_MUSIC := preload("res://Assets/Sound Design/Music/Pixel Swimmer Game Music.wav")
const GAME_OVER_MUSIC := preload("res://Assets/Sound Design/Music/Pixel Swimmer Game Over Music.wav")

#player score
var score := 0:
	set = set_score
var high_score
#background movment speed
var scroll_speed = 300
#making buffs stay away from enemy
const BUFF_AVOID_RADIUS := 32.0
var boss_dead: bool = false
var is_boss_level: bool = false

#FUNCTIONS

func set_score(value):
	score = value
	hud.score = score
	
	if score >= 250 and all_enemy_scenes[1] not in enemy_scenes:  #redcell
		enemy_scenes.append(all_enemy_scenes[1])
	if score >= 500 and all_enemy_scenes[2] not in enemy_scenes:  #mucus
		enemy_scenes.append(all_enemy_scenes[2])
	if score >= 750 and all_enemy_scenes[3] not in enemy_scenes:  #exploding enemy
		enemy_scenes.append(all_enemy_scenes[3])
	if score >= 1000 and all_enemy_scenes[4] not in enemy_scenes: #whitecells
		enemy_scenes.append(all_enemy_scenes[4])
	if score >= 1500 and all_enemy_scenes[5] not in enemy_scenes: #parasite
		enemy_scenes.append(all_enemy_scenes[5])
	if score >= 2000 and all_enemy_scenes[6] not in enemy_scenes: #bossminions
		enemy_scenes.append(all_enemy_scenes[6])

	if score >= 0 and all_buff_scenes[1] not in buff_scenes:    #shieldbuff
		buff_scenes.append(all_buff_scenes[1])
	if score >= 0 and all_buff_scenes[2] not in buff_scenes:    #minion
		buff_scenes.append(all_buff_scenes[2])
	if score >= 500 and all_buff_scenes[3] not in buff_scenes:  #damage
		buff_scenes.append(all_buff_scenes[3])
	if score >= 1500 and all_buff_scenes[4] not in buff_scenes: #antidote
		buff_scenes.append(all_buff_scenes[4])

#READY FUNCTION #run this code when the scene starts and everything is in place
func _ready() -> void:
	start_game(GameSession.mode, GameSession.current_level)
	level_completed_screen.next_level_pressed.connect(_on_next_level_pressed)
	
	enemy_scenes.append(all_enemy_scenes[0])
	buff_scenes.append(all_buff_scenes[0])
	
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

func is_position_over_buff(pos: Vector2) -> bool:
	for buff in buff_container.get_children():
		# Only care about actual buff nodes
		if buff is Buffs:
			var dist := pos.distance_to(buff.global_position)
			if dist < BUFF_AVOID_RADIUS:
				return true
	return false

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
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")

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

func _on_player_laser_shot(laser_scene, location, shooter):
	var laser: Laser = laser_scene.instantiate()
	laser.global_position = location
	laser.original = shooter
	laser.damage = shooter.base_laser_damage * (2 if shooter.has_damage_buff else 1)
	laser_container.add_child(laser)
	player_shooting_sound.play()

func _on_enemy_spawn_timer_timeout() -> void:
	var spawn_pos: Vector2
	var tries := 0
	var max_tries := 10

	while true:
		# Pick a random position like before
		spawn_pos = Vector2(randf_range(50, 500), -50)

		# If this position is not over any buff, accept it
		if not is_position_over_buff(spawn_pos):
			break

		tries += 1
		if tries >= max_tries:
			# Give up to avoid infinite loop – just use this position
			break

	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = spawn_pos
	e.enemy_killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)

func _on_enemy_killed(points, death_sound, source):
	# Play death sound if available
	if death_sound:
		death_sfx_player.stream = death_sound
		death_sfx_player.play()

	# Award points based on the source of the kill
	if is_instance_valid(source):
		if source is Player:
			score += points  # Player kill: use provided 'points'
		elif source is BacteriaMinion:
			score += points
			# Or just score += points if you want minion kills to give full value

	# Update the high score if necessary
	if score > high_score:
		high_score = score

func _on_enemy_hit():
	enemy_hit_sound.play()

func _on_boss_hit():
		var semitones = randf_range(-8.0, -6.0)
		boss_hit_sound.pitch_scale = pow(2.0, semitones / 12.0)
		boss_hit_sound.play()

func _on_player_killed():
	MenuMusic.play_game_over(GAME_OVER_MUSIC)
	player_death_sound.play()
	$UILayer/HUD/PauseButton.visible = false
	$UILayer/HUD.visible = false

	if is_instance_valid(minion):
		minion.queue_free()
		minion = null

	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()

	await get_tree().create_timer(0.5).timeout
	gos.visible = true

#what happens when you pick up a buff (plays sound)
func _on_buff_picked(buff_sound):
	if buff_sound:
		buff_sfx_player.stream = buff_sound
		buff_sfx_player.play()

func _on_buff_spawn_timer_timeout() -> void:
	var buff = buff_scenes.pick_random().instantiate()
	buff.global_position = Vector2(randf_range(50, 500), -50)
	buff.picked_up.connect(_on_buff_picked)

	if buff is BacteriaBuff:
		buff.bacteria_minion_requested.connect(_on_bacteria_minion_requested)

	buff_container.add_child(buff)

func _on_bacteria_minion_requested() -> void:
	if bacteria_minion_scene == null:
		push_warning("bacteria_minion_scene is not set in the inspector")
		return

	# avoid spawning inside physics callback
	call_deferred("_spawn_minion")

func _spawn_minion() -> void:
	if minion_spawn == null:
		push_warning("MinionSpawnPoint not found")
		return

	if is_instance_valid(minion):
		return  # already have one

	minion = bacteria_minion_scene.instantiate()
	minion.global_position = minion_spawn.global_position
	minion.owner_player = player
	enemy_container.add_child(minion)

# ------------------------------------------------------------
# LEVELS LOGIC
# ------------------------------------------------------------
func spawn_level(level_index):
	print("Spawning level:", level_index)
	enemy_spawn_queue.clear()
	var current_level = levels[level_index]
	var last_enemy_type = "Egg"
	
	var shuffled_enemies = []
	var last_enemies = 0
	
	for enemy_type in current_level:
		if enemy_type == last_enemy_type:
			last_enemies = current_level[enemy_type]
		else:
			for i in range(current_level[enemy_type]):
				shuffled_enemies.append(enemy_type)
				
	shuffled_enemies.shuffle()
	enemy_spawn_queue = shuffled_enemies
	
	for i in range(last_enemies):
			enemy_spawn_queue.append(last_enemy_type)
			enemy_queue_index = 0
			story_enemy_spawn_timer.start()

func _on_story_enemy_spawn_timer_timeout():
	if enemy_queue_index < enemy_spawn_queue.size():
		var enemy_type = enemy_spawn_queue[enemy_queue_index]
		var enemy_scene = load("res://Scenes/Enemy Scenes/%s.tscn" % enemy_type)
		var enemy_instance = enemy_scene.instantiate()

		if enemy_type == "Egg":
			if is_boss_level and not boss_dead:
				return
			enemy_instance.global_position = Vector2(273, -50)

		elif enemy_type == "Boss":
			enemy_instance.global_position = Vector2(273, 300)
			enemy_instance.boss_died.connect(_on_boss_died)
			# connect boss-specific signal here, inside the Boss branch
			if enemy_instance.has_signal("spawn_minions"):
				enemy_instance.spawn_minions.connect(_on_boss_spawn_minions.bind(enemy_instance))

		else:
			enemy_instance.global_position = Vector2(randf_range(50, 500), -50)

		# Common connections for all enemies
		if enemy_instance.has_signal("enemy_killed"):
			enemy_instance.enemy_killed.connect(_on_enemy_killed)

		if enemy_instance.has_signal("hit"):
			if enemy_type == "Boss":
				enemy_instance.hit.connect(_on_boss_hit)
			else:
				enemy_instance.hit.connect(_on_enemy_hit)

		enemy_container.add_child(enemy_instance)
		enemy_queue_index += 1
	else:
		story_enemy_spawn_timer.stop()

func _on_boss_spawn_minions(count: int, boss: Boss) -> void:
	for i in range(count):
		var boss_minion := boss_minion_scene.instantiate()
		boss_minion.global_position = boss.global_position  # or around the boss
		enemy_container.add_child(boss_minion)

		# Connect minion death back to this boss
		if boss_minion.has_signal("enemy_killed"):
			boss_minion.enemy_killed.connect(_on_boss_minion_killed.bind(boss))

func _on_boss_minion_killed(points, death_sound, source, boss: Boss) -> void:
	# still let your normal kill logic run if you want:
	_on_enemy_killed(points, death_sound, source)

	if is_instance_valid(boss):
		boss.on_minion_died()

func start_game(mode, current_level):
	# Always disconnect to prevent multiple connections (safe even if not connected)
	timer.timeout.disconnect(_on_enemy_spawn_timer_timeout)
	
	if mode == "survival":
		timer.timeout.connect(_on_enemy_spawn_timer_timeout)
		timer.start()
	elif mode == "story":
		$UILayer/HUD.hide_score()
		timer.stop()
		is_boss_level = levels[current_level].has("Boss")
		boss_dead = not is_boss_level
		spawn_level(current_level)

func show_level_complete_screen():
	$UILayer/LevelCompletedScreen.visible = true
	$UILayer/HUD/PauseButton.visible = false

func _on_next_level_pressed() -> void:
	# Move to the next level index
	GameSession.current_level += 1

	# Optional: check bounds so you don't go past the last level
	if GameSession.current_level >= levels.size():
		# e.g. go back to main menu or show “You finished the game” (change later to chapter complete)
		get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")
		return

	# Reload the game scene so _ready runs again and uses the new current_level
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_boss_died() -> void:
	boss_dead = true
