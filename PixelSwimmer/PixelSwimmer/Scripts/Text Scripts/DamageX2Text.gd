# DamageX2Text.gd
extends Marker2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label  # or the correct path

func show_text() -> void:
	label.text = "DAMAGE X2"   # or whatever you want
	anim_player.play("popup")  # name of your animation

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "popup":
		queue_free()
