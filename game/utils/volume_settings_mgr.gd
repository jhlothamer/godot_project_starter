extends Node


const SOUND_SETTINGS_FILE_PATH = "user://sound_settings.json"


var _data := {}


var _buses = [
	"Master",
	"Music",
	"SoundFx"
]


func _ready():
	_load_settings()


func _load_settings() -> void:
	if FileAccess.file_exists(SOUND_SETTINGS_FILE_PATH):
		var f = FileAccess.open(SOUND_SETTINGS_FILE_PATH,FileAccess.READ)
		if !f:
			printerr("VolumeSettingsMgr: could not open config file")
			return
		var cfg_text = f.get_as_text()
		var test_json_conv = JSON.new()
		if OK != test_json_conv.parse(cfg_text):
			printerr("VolumeSettingsMgr: could not parse config file: %s" % test_json_conv.get_error_message())
			return
		_data = test_json_conv.data
	
	if _data.is_empty():
		save_current_settings()
	else:
		apply_current_settings()


func save_current_settings() -> void:
	for bus_name in _buses:
		var index := AudioServer.get_bus_index(bus_name)
		_data[bus_name] = AudioServer.get_bus_volume_db(index)
	
	var f := FileAccess.open(SOUND_SETTINGS_FILE_PATH, FileAccess.WRITE)
	if !f:
		printerr("VolumeSettingsMgr: could not open setting file to save settings: %s" % SOUND_SETTINGS_FILE_PATH)
		return
	f.store_string(JSON.stringify(_data, "\t"))


func apply_current_settings() -> void:
	for bus_name in _data.keys():
		var index := AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(index, _data[bus_name])


