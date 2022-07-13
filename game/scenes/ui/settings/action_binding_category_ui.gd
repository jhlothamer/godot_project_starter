extends VBoxContainer

onready var _label:Label = $Label
onready var _grid: GridContainer = $HBoxContainer/GridContainer

var _input_settings_category: InputSettingsCategory
var _remap_dlg: InputRemapDialog
var _input_settings_action_wrappers := []

func init(input_settings_category: InputSettingsCategory, remap_dlg: InputRemapDialog) -> void:
	_input_settings_category = input_settings_category
	_remap_dlg = remap_dlg
	_label.text = input_settings_category.name
	_fill_grid()

func _fill_grid():
	_grid.columns = InputMapMgr.bindings_per_action + 1
	for i in InputMapMgr.bindings_per_action:
		var column_header = InputMapMgr.bindings_column_names[i]
		var lbl := Label.new()
		lbl.text = column_header
		_grid.add_child(lbl)
	
	for i in _input_settings_category.actions:
		var action: InputSettingsAction = i
		var lbl := Label.new()
		lbl.text = action.display_name
		_grid.add_child(lbl)
		for j in action._current_events.size():
			var event: InputEvent = action._current_events[j]
			var btn := Button.new()
			btn.rect_min_size.x = 100
			if event:
				btn.text = InputEventDisplayNameUtil.get_display_name(event)
			var wrapper := InputSettingsActionWrapper.new(action, j, btn)
			if OK != btn.connect("pressed", self, "_on_remap_button_pressed", [wrapper]):
				printerr("ActionBindingCategoryUI: can't connect to button's pressed signal??")
			_grid.add_child(btn)
			_input_settings_action_wrappers.append(wrapper)

func _on_remap_button_pressed(wrapper: InputSettingsActionWrapper) -> void:
	_remap_dlg.remap(wrapper)


func get_wrappers() -> Array:
	return _input_settings_action_wrappers


func reset_validity() -> void:
	for wrapper in _input_settings_action_wrappers:
		wrapper.set_validity(true)


func reset() -> void:
	for wrapper in _input_settings_action_wrappers:
		wrapper.reset()


