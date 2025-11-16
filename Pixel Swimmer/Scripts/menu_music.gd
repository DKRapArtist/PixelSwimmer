extends Node

@onready var player := AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.bus = "Master"
	player.autoplay = false
	# Important: ignore global pause
	process_mode = Node.PROCESS_MODE_ALWAYS

#Plays menu music once
func play_menu_music(stream: AudioStream):
	if player.stream != stream:
		player.stream = stream
		player.play()

#Stops menu music
func stop_menu_music():
	player.stop()

func play_game_over(stream: AudioStream):
	# Stop any current music (menu or game)
	player.stop()
	# Switch to game over track and play it once
	player.stream = stream
	player.play()
