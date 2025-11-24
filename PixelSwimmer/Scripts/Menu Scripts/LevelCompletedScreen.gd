extends Node2D

signal next_level_pressed

func _on_next_level_pressed() -> void:
	get_tree().paused = false
	emit_signal("next_level_pressed")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")
