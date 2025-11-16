extends Node2D

func _ready():
	get_tree().paused = false  # ensure menu works normally
	SettingsManager.load_settings()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
