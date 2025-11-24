extends TextureButton

@export var level_index: int = 0
@export var locked_texture: Texture2D

var original_texture: Texture2D

func _ready() -> void:
	# Save the normal (unlocked) texture set in the inspector
	original_texture = texture_normal

	var unlocked := level_index <= GameSession.highest_unlocked_level

	if unlocked:
		texture_normal = original_texture
	else:
		texture_normal = locked_texture
