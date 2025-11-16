extends Node

var master_volume_db := 0.0
var master_muted := false
	
func save_settings():
	var file = FileAccess.open("user://settings.cfg", FileAccess.WRITE)
	file.store_var(master_volume_db)
	file.store_var(master_muted)

func load_settings():
	if FileAccess.file_exists("user://settings.cfg"):
		var file = FileAccess.open("user://settings.cfg", FileAccess.READ)
		master_volume_db = file.get_var()
		master_muted = file.get_var()
	apply_settings()

func apply_settings():
	AudioServer.set_bus_volume_db(0, master_volume_db)
	AudioServer.set_bus_mute(0, master_muted)
