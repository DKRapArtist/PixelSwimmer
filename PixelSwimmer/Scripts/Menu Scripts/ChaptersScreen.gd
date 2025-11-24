class_name ChaptersScreen
extends Node2D

@onready var chapter_2: TextureButton = $Buttons/Chapter2
@onready var chapter_3: TextureButton = $Buttons/Chapter3
@onready var chapter_4: TextureButton = $Buttons/Chapter4

func _ready() -> void:
	# Lock level 2 if highest_unlocked_level < 1
	chapter_2.disabled = GameSession.highest_unlocked_chapter < 1
	chapter_3.disabled = GameSession.highest_unlocked_chapter < 2
	chapter_4.disabled = GameSession.highest_unlocked_chapter < 3

func _on_chapter_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/Chapters/Chapter1.tscn")

func _on_chapter_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/Chapters/ComingSoonScreen.tscn")

func _on_chapter_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/Chapters/ComingSoonScreen.tscn")

func _on_chapter_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/Chapters/ComingSoonScreen.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/main_menu.tscn")
