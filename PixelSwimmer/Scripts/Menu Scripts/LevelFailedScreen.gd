extends Node2D
	
func _on_try_again_pressed() -> void:
	get_tree().paused = false     # <-- FIX
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false     # <-- FIX
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")
