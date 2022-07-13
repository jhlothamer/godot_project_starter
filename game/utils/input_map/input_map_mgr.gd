extends Node

signal input_settings_updated()

const INPUT_MAP_SETTING_CFG_FILE_PATH = "res://assets/data/input_map_setting_cfg.json"
const BINDINGS_TYPE_TO_TYPE_NAME := {
	"key": "InputEventKey",
	"pad": "InputEventJoypadButton",
	"mouse": "InputEventMouseButton",
	# "any" or "*" also allowed - means all above are allowed for an action binding
}


var bindings_per_action := 2
var bindings_column_names := []
var bindings_column_types := []

var _settings := []
var _settings_save_file_path := "user://input_map_settings.json"
var _mouse_settings: InputMouseSettings


func _ready():
	_read_settings_cfg(_read_input_map_settings())
	for cat in _settings:
		cat.apply()


func _read_settings_cfg(settings_data:Dictionary) -> void:
	_settings = []
	var f = File.new()
	if !f.file_exists(INPUT_MAP_SETTING_CFG_FILE_PATH):
		printerr("InputMapMgr: Missing config file: %s" % INPUT_MAP_SETTING_CFG_FILE_PATH)
		return
	if OK != f.open(INPUT_MAP_SETTING_CFG_FILE_PATH,File.READ):
		printerr("InputMapMgr: could not open config file")
		return
	var cfg_text = f.get_as_text()
	f.close()

	var results := JSON.parse(cfg_text)
	if results.error!= OK:
		printerr("InputMapMgr: could not parse config file: %s" % results.error_string)
		return

	var cfg_data = results.result

	_settings_save_file_path = cfg_data["settings_save_file_path"]
	bindings_per_action = cfg_data["bindings_per_action"]
	bindings_column_names = cfg_data["bindings_column_names"]

	_interpret_bindings_column_types(cfg_data["bindings_column_types"])

	_mouse_settings = InputMouseSettings.new(cfg_data["mouse_settings"])
	_mouse_settings.load_data(settings_data)
	
	var category_reader := InputSettingsCategoryReader.new(bindings_per_action, bindings_column_types)

	for cat in cfg_data["categories"]:
		_settings.append(category_reader.read(cat, settings_data))


func _interpret_bindings_column_types(type_string_array: Array) -> void:
	bindings_column_types = []
	var i = 0
	for type_string in type_string_array:
		i += 1
		if i > bindings_per_action:
			break
		if type_string == "any" or type_string == "*":
			bindings_column_types.append(BINDINGS_TYPE_TO_TYPE_NAME.keys())
		else:
			pass
			var parts = type_string.split("|")
			var binding_array := []
			for part in parts:
				if !BINDINGS_TYPE_TO_TYPE_NAME.has(part):
					printerr("InputMapMgr: unrecognized binding type string: %s" % part)
					continue
				binding_array.append(BINDINGS_TYPE_TO_TYPE_NAME[part])
			bindings_column_types.append(binding_array)


func _read_input_map_settings() -> Dictionary:
	var f = File.new()
	if !f.file_exists(_settings_save_file_path):
		return {}
	f.open(_settings_save_file_path, File.READ)
	var settings_text = f.get_as_text()
	var results := JSON.parse(settings_text)
	if results.error != OK:
		printerr("InputMapMgr: could not parse config file: %s" % results.error_string)
		f.close()
		return {}
	
	var settings_data: Dictionary = results.result
	f.close()
	return settings_data

	
	
func get_input_settings_categories() -> Array:
	
	var dup := []
	for setting in _settings:
		dup.append(setting.duplicate())
	
	return dup

func get_mouse_settings() -> InputMouseSettings:
	return _mouse_settings.duplicate()

func save_and_apply(actions: Array, mouse_settings: InputMouseSettings) -> bool:
	for action in actions:
		action.apply()

	_mouse_settings.invert_y = mouse_settings.invert_y
	_mouse_settings.sensitivity = mouse_settings.sensitivity

	emit_signal("input_settings_updated")

	var data := {}

	_mouse_settings.save_data(data)
	
	for action in actions:
		if action._export_data:
			data[action.action_name] = InputEventUtil.serialize_input_events(action._current_events)
	
	var f := File.new()
	if OK != f.open(_settings_save_file_path, File.WRITE_READ):
		printerr("InputMapMgr: Could not save settings file!!")
		return false
	
	var data_string = JSON.print(data, "\t")
	
	f.store_string(data_string)
	f.close()
	
	# refresh data completely - in case player reset to default
	_read_settings_cfg(_read_input_map_settings())
	
	
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


func _event_to_key_string(event: InputEvent) -> String:
	if event is InputEventKey:
		var e: InputEventKey = event
		var code = e.scancode if e.scancode > 0 else e.physical_scancode
		return "key:%d" % [code]
	if event is InputEventMouseButton:
		var e: InputEventMouseButton = event
		return "mouse:%d" % [e.button_index]
	if event is InputEventJoypadButton:
		var e: InputEventJoypadButton = event
		return "pad:%d" % [e.button_index]
	
	
	return "??"

