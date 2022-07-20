class_name InputSettingsCategoryReader
extends Reference

var _bindings_per_action: int
var _bindings_types: Array

func _init(bindings_per_action: int, bindings_types: Array) -> void:
	_bindings_per_action = bindings_per_action
	_bindings_types = bindings_types

func read(category_data: Dictionary, settings_data: Dictionary) -> InputSettingsCategory:
	var category := InputSettingsCategory.new()
	
	category.name = category_data["name"]
	for a in category_data["actions"]:
		var action = InputSettingsAction.new(a["action_name"], a["display_name"])
		if !InputMap.has_action(action.action_name):
			printerr("InputSettingsCategoryReader: action names is not defined in the input map: '%s'" % action.action_name)
			continue
		action._default_events = InputEventUtil.duplicate_events(_order_event_list(InputMap.get_action_list(action.action_name)))
		if settings_data.has(action.action_name):
			action._current_events = InputEventUtil.deserialize_input_events(settings_data[action.action_name])
			action._export_data = true
			action._applied = false
		else:
			action._current_events = InputEventUtil.duplicate_events(action._default_events)
		category.actions.append(action)

	return category


func _order_event_list(events: Array) -> Array:
	var ordered_list := []
	for allowed_events in _bindings_types:
		var matching_event: InputEvent
		for event in events:
			if allowed_events.has(event.get_class()):
				matching_event = event
				break
		if matching_event:
			events.erase(matching_event)
		ordered_list.append(matching_event)
	return ordered_list

