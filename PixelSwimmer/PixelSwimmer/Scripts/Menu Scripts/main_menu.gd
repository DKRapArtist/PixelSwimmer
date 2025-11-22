extends Node2D

#variables
const MENU_MUSIC := preload("res://Assets/Sound Design/Music/Pixel Swimmer Menu Music.wav")

func _ready():
	get_tree().paused = false  # ensure menu works normally
	SettingsManager.load_settings()
	#loads menu music
	MenuMusic.play_menu_music(MENU_MUSIC)

#Main Menu Button Connections
func _on_survival_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")

func _on_story_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/Chapter1.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
