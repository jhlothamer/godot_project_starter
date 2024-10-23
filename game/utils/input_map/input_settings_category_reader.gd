class_name InputSettingsCategoryReader
extends RefCounted

var _binding_columns:Array[InputMapBindingColumnCfg]


func _init(binding_columns:Array[InputMapBindingColumnCfg]) -> void:
	_binding_columns = binding_columns


func read(category_data: InputMapCategoryCfg, settings_data: Dictionary) -> InputSettingsCategory:
	var category := InputSettingsCategory.new()
	
	category.name = category_data.cateogry_name
	for a in category_data.actions:
		var action = InputSettingsAction.new(a.action_name, a.display_name)
		if !InputMap.has_action(action.action_name):
			printerr("InputSettingsCategoryReader: action names is not defined in the input map: '%s'" % action.action_name)
			continue
		action._default_events = InputEventUtil.duplicate_events(_order_event_list(InputMap.action_get_events(action.action_name)))
		if settings_data.has(action.action_name):
			action._current_events = InputEventUtil.deserialize_input_events(settings_data[action.action_name])
			action._export_data = true
			action._applied = false
		else:
			action._current_events = InputEventUtil.duplicate_events(action._default_events)
		category.actions.append(action)

	return category


func _order_event_list(events: Array[InputEvent]) -> Array:
	var ordered_list := []
	for binding_column:InputMapBindingColumnCfg in _binding_columns:
		pass
		var matching_event: InputEvent = null
		for event in events:
			if binding_column.is_valid_input_type(event.get_class()):
				matching_event = event
				break
		if matching_event:
			events.erase(matching_event)
		ordered_list.append(matching_event)
	
	return ordered_list

