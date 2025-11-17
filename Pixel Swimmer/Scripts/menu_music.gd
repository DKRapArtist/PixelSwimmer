extends Node

#onready variables
@onready var player := AudioStreamPlayer.new()

#variables
var max_pitch_scale: float = 1.5        # highest speed you want
var min_pitch_scale: float = 1.0        # starting speed
var pitch_change_rate: float = 0.0002    # how fast it ramps up (tweak this)

func _ready():
	add_child(player)
	player.bus = "Master"
	player.autoplay = false
	# Important: ignore global pause
	process_mode = Node.PROCESS_MODE_ALWAYS
# Start at normal pitch
	player.pitch_scale = min_pitch_scale
	
func _process(delta: float) -> void:
	# Gradually increase pitch over time, similar idea to your timer code
	if player.playing:
		if player.pitch_scale < max_pitch_scale:
			player.pitch_scale += pitch_change_rate * delta
		elif player.pitch_scale > max_pitch_scale:
			player.pitch_scale = max_pitch_scale
	
func play_menu_music(stream: AudioStream) -> void:
	# If this music is already playing, do nothing
	if player.playing and player.stream == stream:
		return

	# If it's a different stream, switch to it
	if player.stream != stream:
		player.stream = stream

	# Reset pitch when starting menu music
	player.pitch_scale = 1.0
	player.play()

#Stops menu music
func stop_menu_music():
	player.stop()

func play_game_over(stream: AudioStream):
	# Stop any current music (menu or game)
	player.stop()
	# Reset pitch for game over so it plays "clean"
	player.pitch_scale = 1.0
	# Switch to game over track and play it once
	player.stream = stream
	player.play()
