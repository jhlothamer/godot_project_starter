class_name InputRemapDialog
extends Window


const BINDINGS_TYPE_TO_MESSAGE_NAME := {
	InputMapBindingColumnCfg.BindingColumnTypes.KeyBoard: "Key",
	InputMapBindingColumnCfg.BindingColumnTypes.Mouse: "Mouse Button",
	InputMapBindingColumnCfg.BindingColumnTypes.GamePad: "Gamepad Button",
}


@onready var _label: Label = $MarginContainer/VBoxContainer/Label

var _binding_column:InputMapBindingColumnCfg
var _current_action: InputSettingsActionWrapper


func _ready():
	size = min_size

func remap_input(action: InputSettingsActionWrapper) -> void:
	if visible:
		return
	_current_action = action
	title = "Remap %s" % action.get_display_name()
	_binding_column = InputMapMgr.settings_config.binding_columns[action.binding_index]
	_init_label(InputMapMgr.settings_config.binding_columns[action.binding_index].binding_types)
	set_process_input(true)
	popup_centered()


func _init_label(binding_column_types:InputMapBindingColumnCfg.BindingColumnTypes) -> void:
	var binding_type_label_text:Array[String]
	for binding_type:InputMapBindingColumnCfg.BindingColumnTypes in BINDINGS_TYPE_TO_MESSAGE_NAME.keys():
		if binding_type & binding_column_types > 0: binding_type_label_text.append(BINDINGS_TYPE_TO_MESSAGE_NAME[binding_type])
	
	_label.text = "Press %s" % " or ".join(binding_type_label_text).strip_edges()


func _input(event: InputEvent) -> void:
	if !event.is_pressed():
		return
	var event_class:String = event.get_class()
	if !_binding_column.is_valid_input_type(event_class):
		return
	_label.text = InputEventDisplayNameUtil.get_display_name(event)
	await get_tree().create_timer(.5).timeout
	if !visible:
		return
	_current_action.set_event_binding(event)
	hide()
	return


func _on_InputRemapDialog_popup_hide():
	set_process_input(false)


func _on_CancelBtn_pressed():
	hide()


func _on_close_requested() -> void:
	hide()
