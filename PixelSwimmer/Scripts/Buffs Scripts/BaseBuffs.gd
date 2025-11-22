class_name Buffs
extends Area2D

@export var health_text_scene: PackedScene

#signals
signal picked_up(buff_sound)

#export variables
@export var buff_speed: int = 200
@export var buff_type: = "heal"
@export var amount: = 1
@export var buff_sound: AudioStream

func _on_body_entered(body):
	if body is Player:
		
		if buff_type == "heal":
			body.heal(int(amount))
			show_health_text(body)
			
		picked_up.emit(buff_sound)
		queue_free()

func _physics_process(delta: float) -> void:
	global_position.y += buff_speed * delta

func show_health_text(player: Node) -> void:
	var popup = health_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
