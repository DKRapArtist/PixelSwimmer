extends Control

#variables
var origin : String = "main_menu"

#functions
func _ready():
	get_tree().paused = false
	SettingsManager.load_settings()
	update_settings_ui()

func open_from_pause():
	origin = "pause_menu"
	visible = true # Show options panel
	update_settings_ui()

func open_from_main():
	origin = "main_menu"
	visible = true # Show options panel
	update_settings_ui()

func _on_back_pressed():
	SettingsManager.save_settings()
	if origin == "pause_menu":
		visible = false  # just hide, don't free
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_volume_value_changed(value: float):
	SettingsManager.master_volume_db = value
	SettingsManager.apply_settings()

func _on_mute_toggled(toggled_on: bool):
	SettingsManager.master_muted = toggled_on
	SettingsManager.apply_settings()

func update_settings_ui():
	$VolumeControl/Mute.button_pressed = SettingsManager.master_muted
	$VolumeControl/Volume.value = SettingsManager.master_volume_db
