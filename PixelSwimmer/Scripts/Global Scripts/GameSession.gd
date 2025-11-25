extends Node

var mode = "survival"
var current_level = 0
var current_chapter = 0
var high_score: int = 0
var highest_unlocked_level: int = 0
var highest_unlocked_chapter: int = 0

func _ready():
	load_save()


func load_save():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)

	if save_file:
		var length := save_file.get_length()
		if length >= 12:
			high_score = save_file.get_32()
			highest_unlocked_level = save_file.get_32()
			highest_unlocked_chapter = save_file.get_32()
		elif length >= 8:
			high_score = save_file.get_32()
			highest_unlocked_level = save_file.get_32()
			highest_unlocked_chapter = 0
		else:
			high_score = save_file.get_32()
			highest_unlocked_level = 0
			highest_unlocked_chapter = 0
	else:
		high_score = 0
		highest_unlocked_level = 0
		highest_unlocked_chapter = 0
