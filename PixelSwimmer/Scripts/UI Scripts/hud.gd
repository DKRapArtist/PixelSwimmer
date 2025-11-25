extends Control

@onready var score =$Score:
	set(value):
		score.text = "Score: " + str(value)

func hide_score():
	$Score.hide()

func show_score():
	$Score.show()

func set_level_text(text: String):
	$LevelLabel.text = text

func update_kills(k):
	$KillLabel.text = "Kills: %d" % k
