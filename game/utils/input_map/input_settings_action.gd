class_name InputSettingsAction
extends Reference


var action_name := ""
var display_name := ""
var _default_events := []
var _current_events := []
var _applied := true
var _export_data := false


func _init(an: String, dn: String, for_dup: bool = false) -> void:
	action_name = an
	display_name = dn
	if for_dup:
		return


func duplicate():
	var dup = get_script().new(action_name, display_name)
	dup._default_events = InputEventUtil.duplicate_events(_default_events)
	dup._current_events = InputEventUtil.duplicate_events(_current_events)
	dup._applied = _applied
	dup._export_data = _export_data
	return dup


func reset() -> void:
	if InputEventUtil.are_event_arrays_same(_default_events, _current_events):
		return
	_applied = false
	_current_events = InputEventUtil.duplicate_events(_default_events)
	# set flag to not export data later - no need to export defaults
	_export_data = false


func apply() -> void:
	if _applied:
		return
	InputMap.action_erase_events(action_name)
	for event in _current_events:
		if event:
			InputMap.action_add_event(action_name, event)
	_applied = true


func set_event_binding(binding_index: int, event: InputEvent) -> void:
	_current_events[binding_index] = InputEventUtil.duplicate_event(event)
	_applied = false
	# if bindings changed - set flag to export later
	_export_data = true


func has_default_key_binding(key: int) -> bool:
	for e in _default_events:
		if e is InputEventKey:
			var ek: InputEventKey = e
			if ek.scancode == key or ek.physical_scancode == key:
				return true
	return false
