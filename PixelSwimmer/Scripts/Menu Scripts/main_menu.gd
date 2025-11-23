extends Node2D

#variables


func _ready():
	MusicManager.play_menu_music()
	get_tree().paused = false  # ensure menu works normally
	SettingsManager.load_settings()
	#loads menu music

#Main Menu Button Connections
func _on_survival_pressed() -> void:
	GameSession.mode = "survival"
	GameSession.current_level = 0
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_story_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/ChaptersScreen.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
