extends Control

func set_score(value):
	$Panel/Score.text = "Score:  " + str(value)

func set_high_score(value):
	$"Panel/HighScore".text = "High Score: " + str(value)



#try again button
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")
