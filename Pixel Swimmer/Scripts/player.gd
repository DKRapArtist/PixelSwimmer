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

# ───────────────────────────────────────────────
# Node References
# ───────────────────────────────────────────────
@onready var muzzle: Node2D = $Muzzle
@onready var red_hearts := $health_bar/RedHearts
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
	for i in range(red_hearts_list.size()):
		red_hearts_list[i].visible = (i < hp)

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
func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

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
	hp += amount
	if hp > max_hp:
		hp = max_hp
	update_heart_display()
	low_health_alert()

# ───────────────────────────────────────────────
# COLLISION WITH ENEMY
# ───────────────────────────────────────────────
func _on_body_entered(body):
	if body is Enemy:
		body.take_damage(1, self)  # Pass the correct source!
		take_damage(1)
