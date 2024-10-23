## configuration for input map settings
class_name InputMapSettingsCfg
extends Resource

## path to user's input map settings json file (should start with user://)
@export_file var settings_save_file_path := "user://input_map_settings.json"
## The types of input that can be re-mapped for all input actions with name and type (keyboard, mouse, gamepad)
@export var binding_columns:Array[InputMapBindingColumnCfg] = []
## mouse settings configuration
@export var mouse_settings := InputMapMouseSettingsCfg.new()
## categories of input actions that can be re-mapped by player
@export var input_map_categories:Array[InputMapCategoryCfg] = []
