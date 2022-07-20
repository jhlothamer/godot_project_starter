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
	var f = File.new()
	if f.file_exists(SOUND_SETTINGS_FILE_PATH):
		if OK != f.open(SOUND_SETTINGS_FILE_PATH,File.READ):
			printerr("VolumeSettingsMgr: could not open config file")
			return
		var cfg_text = f.get_as_text()
		f.close()
		var results := JSON.parse(cfg_text)
		if results.error!= OK:
			printerr("VolumeSettingsMgr: could not parse config file: %s" % results.error_string)
			return
		_data = results.result
	
	if _data.empty():
		save_current_settings()
	else:
		apply_current_settings()


func save_current_settings() -> void:
	for bus_name in _buses:
		var index := AudioServer.get_bus_index(bus_name)
		_data[bus_name] = AudioServer.get_bus_volume_db(index)
	
	var f := File.new()
	if OK != f.open(SOUND_SETTINGS_FILE_PATH, File.WRITE):
		printerr("VolumeSettingsMgr: could not open setting file to save settings: %s" % SOUND_SETTINGS_FILE_PATH)
		return
	f.store_string(JSON.print(_data, "\t"))
	f.close()


func apply_current_settings() -> void:
	for bus_name in _data.keys():
		var index := AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(index, _data[bus_name])


