extends Control

@onready var score =$Score:
	set(value):
		score.text = "Score: " + str(value)

func hide_score():
	$Score.hide()

func show_score():
	$Score.show()
