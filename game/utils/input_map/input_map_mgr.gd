extends Node


signal input_settings_updated()


const INPUT_MAP_SETTING_CFG_FILE_PATH = "res://assets/data/input_map_settings_cfg.tres"


var settings_config:InputMapSettingsCfg = ResourceLoader.load(INPUT_MAP_SETTING_CFG_FILE_PATH)


var _settings:Array[InputSettingsCategory] = []
var _mouse_settings: InputMouseSettings


func _ready():
	_read_settings_cfg()
	for cat in _settings:
		cat.apply()


## combine settings configuration with settings player may have changed
## populates: _mouse_settings, and _settings
func _read_settings_cfg() -> void:
	_settings = []

	var player_settings_data:Dictionary = _read_player_input_map_settings()

	_mouse_settings = InputMouseSettings.new(settings_config.mouse_settings)
	_mouse_settings.load_data(player_settings_data)
	
	var category_reader := InputSettingsCategoryReader.new(settings_config.binding_columns)
	for cat in settings_config.input_map_categories:
		_settings.append(category_reader.read(cat, player_settings_data))


## reads player's setting file and convert it to a Dictionary
func _read_player_input_map_settings() -> Dictionary:
	if !FileAccess.file_exists(settings_config.settings_save_file_path):
		return {}
	var f = FileAccess.open(settings_config.settings_save_file_path, FileAccess.READ)
	var settings_text = f.get_as_text()
	var test_json_conv = JSON.new()
	var result = test_json_conv.parse(settings_text)
	if OK != result:
		printerr("InputMapMgr: could not parse config file: error=%d, %s" % [result, test_json_conv.get_error_message()])
		return {}
	
	var settings_data: Dictionary = test_json_conv.data
	return settings_data


func _save_player_input_map_settings(data: Dictionary) -> bool:
	var f = FileAccess.open(settings_config.settings_save_file_path, FileAccess.WRITE_READ)
	if !f:
		printerr("InputMapMgr: Could not save settings file!!")
		return false
	
	var data_string = JSON.stringify(data, "\t")
	
	f.store_string(data_string)
	return true

func _event_to_key_string(event: InputEvent) -> String:
	if event is InputEventKey:
		var e: InputEventKey = event
		var code = e.keycode if e.keycode > 0 else e.physical_keycode
		return "key:%d" % [code]
	if event is InputEventMouseButton:
		var e: InputEventMouseButton = event
		return "mouse:%d" % [e.button_index]
	if event is InputEventJoypadButton:
		var e: InputEventJoypadButton = event
		return "pad:%d" % [e.button_index]
	
	return "??"


## gets a dupliate of input settings which can be thrown away if player doesn't save changes
func get_input_settings_categories() -> Array[InputSettingsCategory]:
	var duplicate_settings:Array[InputSettingsCategory] = []
	for setting in _settings:
		duplicate_settings.append(setting.duplicate())
	return duplicate_settings


## gets a dupliate of mouse settings which can be thrown away if player doesn't save changes
func get_mouse_settings() -> InputMouseSettings:
	return _mouse_settings.duplicate()


## applies and saves given settings
func save_and_apply(actions: Array[InputSettingsAction], mouse_settings: InputMouseSettings) -> bool:
	for action in actions:
		action.apply()

	_mouse_settings.invert_y = mouse_settings.invert_y
	_mouse_settings.sensitivity = mouse_settings.sensitivity
	input_settings_updated.emit()

	var data := {}

	_mouse_settings.save_data(data)
	
	for action in actions:
		if action._export_data:
			data[action.action_name] = InputEventUtil.serialize_input_events(action._current_events)

	if !_save_player_input_map_settings(data):
		return false
	
	# refresh data completely - in case player reset to default
	_read_settings_cfg()
	
	return true


# determines which input settings actions and bindings overlap and are therefore invalid
# returns array of dictionaries.  Dictionaries contians "action" reference and "binding_index" index into the event
func get_invalid_input_settings_actions(all_actions: Array) -> Array:
	var validity_check_dictionary := {}
	for i in all_actions:
		var action: InputSettingsAction = i
		var binding_index := -1
		for j in action._current_events:
			binding_index += 1
			if !j:
				continue
			var event: InputEvent = j
			var key = _event_to_key_string(event)
			if !validity_check_dictionary.has(key):
				validity_check_dictionary[key] = [{"action": action, "binding_index": binding_index}]
			else:
				validity_check_dictionary[key].append({"action": action, "binding_index": binding_index})

	var invalid_actions := []

	for key in validity_check_dictionary.keys():
		if validity_check_dictionary[key].size() < 2:
			continue
		
		for action_binding_index_dictionary in validity_check_dictionary[key]:
			invalid_actions.append(action_binding_index_dictionary)
	
	return invalid_actions

