extends Node2D

#export variables

#variables

#functions

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
#back button
func _on_back_pressed() -> void:
	$".".visible = false
	$"../Pause".visible = true

#mute button
func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

#volume knob
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)
