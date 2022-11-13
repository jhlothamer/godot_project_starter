extends VBoxContainer

@onready var _bus_controls := {
	"Master": [$HBoxContainer/GridContainer/MasterVolumeLabel, $HBoxContainer/GridContainer/MasterVolumeHSlider],
	"Music": [$HBoxContainer/GridContainer/MusicVolumeLabel, $HBoxContainer/GridContainer/MusicVolumeHSlider],
	"SoundFx": [$HBoxContainer/GridContainer/SoundFxVolumeLabel, $HBoxContainer/GridContainer/SoundFxVolumeHSlider],
}
@onready var _update_volume_sound: AudioStreamPlayer = $UpdateVolumeSound


func _ready():
	init()


func init() -> void:
	for bus_name in _bus_controls.keys():
		var bus_index = AudioServer.get_bus_index(bus_name)
		if bus_index < 0:
			for i in _bus_controls[bus_name]:
				i.queue_free()
			_bus_controls[bus_name] = []
			continue
		var slider:HSlider = _bus_controls[bus_name][1]
		slider.value = AudioServer.get_bus_volume_db(bus_index)
		if !slider.is_connected("value_changed",Callable(self,"_on_volume_slider_value_changed")):
			if OK != slider.connect("value_changed",Callable(self,"_on_volume_slider_value_changed").bind(bus_index)):
				printerr("VolumeSettingsUI: couldn't connect to volume slider value_changed signal!!")


func save() -> void:
	VolumeSettingsMgr.save_current_settings()


func reset() -> void:
	cancel()


func cancel() -> void:
	VolumeSettingsMgr.apply_current_settings()
	init()


func _on_volume_slider_value_changed(value: float, bus_index: int) -> void:
	AudioServer.set_bus_volume_db(bus_index, value)
	if !_update_volume_sound.playing:
		_update_volume_sound.play()


func _on_SoundFxVolumeHSlider_value_changed(_value):
	if !_update_volume_sound.playing:
		_update_volume_sound.play()

