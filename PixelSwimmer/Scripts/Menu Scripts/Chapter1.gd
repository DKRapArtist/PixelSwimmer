extends Node2D

func _on_level_1_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 0
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_2_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 1
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_3_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 2
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_4_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 3
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_5_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 4
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_6_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 5
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_7_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 6
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_8_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 7
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_level_9_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 8
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_boss_level_pressed() -> void:
	GameSession.mode = "story"
	GameSession.current_level = 9
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/ChaptersScreen.tscn")
