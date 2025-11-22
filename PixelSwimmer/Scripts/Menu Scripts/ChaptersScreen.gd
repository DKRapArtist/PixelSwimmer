class_name ChaptersScreen
extends Node2D



func _on_chapter_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/Chapters/Chapter1.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")
