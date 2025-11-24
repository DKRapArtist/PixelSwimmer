extends Node2D




func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/ChaptersScreen.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")
