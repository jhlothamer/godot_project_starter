extends ScrollContainer

signal remap_started()
signal remap_ended()

const ACTION_BINDING_CATEGORY_UI = preload("res://scenes/ui/settings/action_binding_category_ui.tscn")

onready var _mouse_settings_ui = $ControlSettingsCategoryContainer/MouseSettingsUI
onready var _input_remap_dlg:InputRemapDialog = $ControlSettingsCategoryContainer/InputRemapDialog
onready var _action_binding_categories_container: VBoxContainer = $ControlSettingsCategoryContainer/ActionBindingCategoriesContainer

var _mouse_settings: InputMouseSettings
var _input_settings_categories := []

func _ready():
	init()


func init() -> void:
	_mouse_settings = InputMapMgr.get_mouse_settings()
	_mouse_settings_ui.init(_mouse_settings)
	
	for child in _action_binding_categories_container.get_children():
		child.queue_free()
	
	_input_settings_categories = InputMapMgr.get_input_settings_categories()
	for i in _input_settings_categories:
		var category:InputSettingsCategory = i
		var category_ui = ACTION_BINDING_CATEGORY_UI.instance()
		_action_binding_categories_container.add_child(category_ui)
		category_ui.init(category, _input_remap_dlg)

func _on_InputRemapDialog_about_to_show():
	emit_signal("remap_started")


func _on_InputRemapDialog_popup_hide():
	emit_signal("remap_ended")


func validate() -> String:
	var all_input_settings_actions := []
	for i in _input_settings_categories:
		var category: InputSettingsCategory = i
		all_input_settings_actions.append_array(category.actions)
	
	var validation_results = InputMapMgr.get_invalid_input_settings_actions(all_input_settings_actions)
	
	var input_settings_action_wrappers := []
	for category_ui in _action_binding_categories_container.get_children():
		category_ui.reset_validity()
		input_settings_action_wrappers.append_array(category_ui.get_wrappers())
	
	#"action" reference and "binding_index"
	for i in validation_results:
		var validation_result: Dictionary = i
		var action: InputSettingsAction = validation_result["action"]
		var binding_index: int = validation_result["binding_index"]
		for j in input_settings_action_wrappers:
			var wrapper: InputSettingsActionWrapper = j
			if action == wrapper.input_settings_action and binding_index == wrapper.binding_index:
				wrapper.set_validity(false)
	
	return "" if validation_results.empty() else "Unable to save Control settings.  Please fix indicated issues."


func reset() -> void:
	for category_ui in _action_binding_categories_container.get_children():
		category_ui.reset()


func save() -> void:
	var all_input_settings_actions := []
	for i in _input_settings_categories:
		var category: InputSettingsCategory = i
		all_input_settings_actions.append_array(category.actions)
	
	var _discard = InputMapMgr.save_and_apply(all_input_settings_actions, _mouse_settings)


