class_name Player
extends CharacterBody2D

# ───────────────────────────────────────────────
# Signals
# ───────────────────────────────────────────────
signal laser_shot(laser_scene, location)
signal killed
signal hit

# ───────────────────────────────────────────────
# Configurable Variables
# ───────────────────────────────────────────────
@export var SPEED := 300.0
@export var SHOOT_MULTIPLIER := 1.3
@export var margin := 32

#variables

var laser_scene := preload("res://Scenes/laser.tscn")

# Slow effect
var is_slowed := false

# HP + UI
@export var max_hp := 10
@export var hp: int = 3

var red_hearts_list: Array[TextureRect] = []
var black_hearts_list: Array[TextureRect] = []
var blue_hearts_list: Array[TextureRect] = []

#player buff defaults
var can_heal: bool = true
var is_poisoned: bool = false
var has_shield: bool = false
var shield_time_left: float = 0.0

# ───────────────────────────────────────────────
# Node References
# ───────────────────────────────────────────────
@onready var muzzle: Node2D = $Muzzle
@onready var red_hearts := $health_bar/RedHearts
@onready var black_hearts := $health_bar/BlackHearts
@onready var blue_hearts := $health_bar/BlueHearts
@onready var damage_sfx := $TakeDamage
@onready var low_health_sfx := $LowHealth

# ───────────────────────────────────────────────
# READY
# ───────────────────────────────────────────────
func _ready():
	# Load heart UI into list
	for heart in red_hearts.get_children():
		if heart is TextureRect:
			red_hearts_list.append(heart)

	for heart in black_hearts.get_children():
		if heart is TextureRect:
			black_hearts_list.append(heart)

	for heart in blue_hearts.get_children():
		if heart is TextureRect:
			blue_hearts_list.append(heart)

	# Ensure display matches hp
	update_heart_display()

# ───────────────────────────────────────────────
# SLOW EFFECT
# ───────────────────────────────────────────────
func apply_slow(amount: float, duration: float):
	if is_slowed:
		return

	is_slowed = true
	SPEED *= amount

	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(func():
		if is_instance_valid(self):
			SPEED /= amount
			is_slowed = false)

# ───────────────────────────────────────────────
# UPDATE HEART UI
# ───────────────────────────────────────────────
func update_heart_display():
	for i in range(max_hp):
		if has_shield:
			# Show blue hearts
			blue_hearts_list[i].visible = i < hp
			red_hearts_list[i].visible = false
			black_hearts_list[i].visible = false

		elif is_poisoned:
			# Show black hearts
			black_hearts_list[i].visible = i < hp
			red_hearts_list[i].visible = false
			blue_hearts_list[i].visible = false

		else: 
			# Show red hearts
			red_hearts_list[i].visible = i < hp
			black_hearts_list[i].visible = false
			blue_hearts_list[i].visible = false

# Play low HP alert
func low_health_alert():
	if hp == 1:
		if low_health_sfx and not low_health_sfx.is_playing():
			low_health_sfx.play()
	elif hp > 1:
		if low_health_sfx and low_health_sfx.is_playing():
			low_health_sfx.stop()

# ───────────────────────────────────────────────
# SHOOTING
# ───────────────────────────────────────────────
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if has_shield:
		shield_time_left -= delta
	if shield_time_left <= 0.0:
		shield_time_left = 0.0
		has_shield = false
		update_heart_display()

func shoot():
	var location := muzzle.global_position
	laser_shot.emit(laser_scene, location)

# ───────────────────────────────────────────────
# MOVEMENT + CLAMP
# ───────────────────────────────────────────────
func _physics_process(_delta):
	var direction := Input.get_axis("ui_left", "ui_right")

	# Horizontal movement
	if direction != 0:
		velocity.x = direction * SPEED * SHOOT_MULTIPLIER
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Clamp AFTER move_and_slide, not before
	var screen_size = get_viewport_rect().size
	global_position.x = clamp(global_position.x, margin, screen_size.x - margin)
	global_position.y = clamp(global_position.y, margin, screen_size.y - margin)

# ───────────────────────────────────────────────
# DAMAGE + DEATH
# ───────────────────────────────────────────────
func take_damage(amount: int):
	if has_shield:
		return
		
	hp -= amount
	if hp < 0:
		hp = 0
	damage_sfx.play()

	if hp <= 0:
		die()
		return

	# Still alive:
	low_health_alert()
	update_heart_display()
	hit.emit()

func die():
	killed.emit()
	queue_free()

#Healing
func heal(amount: int):
	#this makes it so NOTHING can heal the player when can_heal is set to false
	if is_poisoned:
		return
		
	hp = clamp(hp + amount, 0, max_hp)
	update_heart_display()
	low_health_alert()

func apply_poison():
	if has_shield:
		return
	is_poisoned = true
	update_heart_display()

func cure_poison():
	is_poisoned = false
	update_heart_display()

func apply_shield(duration):
	if is_poisoned:
		return
	has_shield = true
	shield_time_left = duration
	update_heart_display()
# ───────────────────────────────────────────────
# COLLISION WITH ENEMY
# ───────────────────────────────────────────────
func _on_body_entered(body):
	if body is Enemy:
		body.take_damage(1, self)  # Pass the correct source!
		take_damage(1)
