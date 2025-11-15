extends Node2D

@onready var pause_panel := $Pause
@onready var options_menu := $OptionsMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	_reset_menu()

func _reset_menu():
	pause_panel.visible = true
	options_menu.visible = false

func _resume_game():
	get_tree().paused = false
	visible = false
	_reset_menu()

func _on_resume_pressed():
	_resume_game()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_options_pressed():
	pause_panel.visible = false
	options_menu.visible = true

func _on_quit_pressed():
	get_tree().quit()
