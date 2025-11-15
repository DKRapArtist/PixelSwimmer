class_name Player extends CharacterBody2D

#signals
signal laser_shot(laser_scene, location)
signal killed
signal hit

#Variables
@export var SPEED := 300.0
var margin = 32
var laser_scene = preload("res://Scenes/laser.tscn")
var is_slowed := false

#player hitpoints
var hearts_list : Array[TextureRect]
var max_hp := 3
var hp := max_hp

#onready variables
@onready var muzzle = $Muzzle

#functions

#applys slow to player
func apply_slow(amount: float, duration: float) -> void:
	if is_slowed:
		return
	is_slowed = true
	SPEED *= amount
	
	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(func():
		if is_instance_valid(self):
			SPEED /= amount
			is_slowed = false)

#hearts
func _ready() -> void:
	var hearts_parent = $HealthBar/VBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)
		update_heart_display()

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < hp

func low_health() -> void:
	if hp == 1:
		$LowHealth.play()

#player shooting
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

#player movement
func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * 1.3
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#keeps player inside viewport (breaks if moved away from move_and_slide)
	global_position = global_position.clamp(Vector2(margin, margin), get_viewport_rect().size - Vector2(margin, margin))

func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)

func die():
	killed.emit()
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(1) #hurts enemy
		take_damage(1) #hurts player

func take_damage(amount: int) -> void:
	$TakeDamage.play()
	hp -= amount
	low_health()
	if hp <= 0:
		die()
	else:
		hit.emit()
		update_heart_display()
