extends Node

var master_volume_db := 0.0
var music_volume_db := 0.0
var sfx_volume_db := 0.0

var master_muted := false
var music_muted := false
var sfx_muted := false

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_VERSION := 1

func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	# write a version or a count first
	file.store_32(SETTINGS_VERSION)
	file.store_var(master_volume_db)
	file.store_var(music_volume_db)
	file.store_var(sfx_volume_db)
	file.store_var(master_muted)
	file.store_var(music_muted)
	file.store_var(sfx_muted)
	file.close()
	

func load_settings():
	if not FileAccess.file_exists(SETTINGS_PATH):
		apply_settings()
		return

	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)

	# Try to read version; if it fails, recreate file
	if file.get_length() < 4:
		file.close()
		save_settings() # create fresh file with defaults
		apply_settings()
		return

	var version := file.get_32()

	if version == 1:
		master_volume_db = file.get_var()
		music_volume_db = file.get_var()
		sfx_volume_db = file.get_var()
		master_muted = file.get_var()
		music_muted = file.get_var()
		sfx_muted = file.get_var()
	else:
		# Unknown/old version – recreate with defaults
		file.close()
		save_settings()
		apply_settings()
		return

	file.close()
	apply_settings()

func apply_settings():
	# by index: 0 = Master, 1 = Music, 2 = SFX (depends on your bus order)
	AudioServer.set_bus_volume_db(0, master_volume_db)
	AudioServer.set_bus_mute(0, master_muted)
