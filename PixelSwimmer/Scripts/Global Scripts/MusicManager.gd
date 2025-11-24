extends Node

# export variables
@export var menu_track: AudioStream
@export var story_track: AudioStream
@export var boss_track: AudioStream
@export var survival_track: AudioStream
@export var level_failed_track: AudioStream
@export var level_completed_track: AudioStream
@export var game_over_track: AudioStream

#onready variables
@onready var player := AudioStreamPlayer.new()

#variables
var max_pitch_scale: float = 1.5        # highest speed you want
var min_pitch_scale: float = 1.0        # starting speed
var pitch_change_rate: float = 0.0002    # how fast it ramps up (tweak this)
var ramp_pitch := false

func _ready():
	add_child(player)
	player.bus = "MusicBus"
	player.autoplay = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.pitch_scale = min_pitch_scale
	
func _process(delta: float) -> void:
	if ramp_pitch and player.playing:
		if player.pitch_scale < max_pitch_scale:
			player.pitch_scale += pitch_change_rate * delta
		elif player.pitch_scale > max_pitch_scale:
			player.pitch_scale = max_pitch_scale
	
func _play_music(stream: AudioStream, reset_pitch := true, use_ramp := false) -> void:
	#if the same music is already playing, dont restart it
	if player.stream == stream and player.playing:
		return 
	
	player.stop()
	player.stream = stream
	ramp_pitch = use_ramp
	
	if reset_pitch:
		player.pitch_scale = min_pitch_scale
		
	player.play()


func play_menu_music(_stream := menu_track) -> void:
	_play_music(_stream, true, false)

func play_story_music(_stream := story_track) -> void:
	_play_music(_stream, true, true)

func play_boss_music(_stream := boss_track) -> void:
	_play_music(_stream, true, false)

func play_survival_music(_stream := survival_track) -> void:
	_play_music(_stream, true, false)

func play_levelfailed_music(_stream := level_failed_track) -> void:
	_play_music(_stream, true, false)

func play_levelcompleted_music(_stream := level_completed_track) -> void:
	_play_music(_stream, true, false)

func play_gameover_music(_stream := game_over_track) -> void:
	_play_music(_stream, true, false)

#Stops menu music
func stop_menu_music():
	player.stop()
