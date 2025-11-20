extends Node2D

signal resume_pressed
signal options_pressed
signal main_menu_pressed
signal quit_pressed
signal options_back_pressed

@onready var pause_menu := $Pause
@onready var options_menu := $OptionsMenu

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false

func show_pause():
	visible = true
	pause_menu.visible = true
	options_menu.visible = false

func show_options():
	pause_menu.visible = false
	options_menu.visible = true

func _on_resume_pressed(): emit_signal("resume_pressed")
func _on_options_pressed(): emit_signal("options_pressed")
func _on_main_menu_pressed(): emit_signal("main_menu_pressed")
func _on_quit_pressed(): emit_signal("quit_pressed")
func _on_back_pressed(): emit_signal("options_back_pressed")
