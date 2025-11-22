extends Marker2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label  # or the correct path

func show_text() -> void:
	label.text = "Poisoned"   # or whatever you want
	anim_player.play("PopUp")  # name of your animation

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PopUp":
		queue_free()
