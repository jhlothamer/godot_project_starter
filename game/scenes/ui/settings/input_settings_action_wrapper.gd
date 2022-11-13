class_name InputSettingsActionWrapper
extends RefCounted

var INVALID_ACTION_BINDING_THEME = preload("res://assets/themes/invalid_action_binding.tres")


var input_settings_action: InputSettingsAction
var binding_index: int
var remap_binding_button: Button


func _init(action: InputSettingsAction,binding,remap_button):
	input_settings_action = action
	binding_index = binding
	remap_binding_button = remap_button


func get_display_name():
	return input_settings_action.display_name


func set_event_binding(event: InputEvent):
	if InputEventUtil.are_events_same(event, input_settings_action._current_events[binding_index]):
		return
	input_settings_action.set_event_binding(binding_index, event)
	remap_binding_button.text = InputEventDisplayNameUtil.get_display_name(event)


func set_validity(valid: bool) -> void:
	if valid:
		remap_binding_button.theme = null
	else:
		remap_binding_button.theme = INVALID_ACTION_BINDING_THEME


func reset() -> void:
	set_validity(true)
	input_settings_action.reset()
	var event = input_settings_action._current_events[binding_index]
	if !event:
		remap_binding_button.text = ""
	else:
		remap_binding_button.text = InputEventDisplayNameUtil.get_display_name(event)


