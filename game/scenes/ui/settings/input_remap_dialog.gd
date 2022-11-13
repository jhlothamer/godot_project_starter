class_name InputRemapDialog
extends Window


const BINDINGS_TYPE_TO_MESSAGE_NAME := {
	"InputEventKey": "Key",
	"InputEventJoypadButton": "Gamepad Button",
	"InputEventMouseButton": "Mouse Button",
}


@onready var _label: Label = $MarginContainer/VBoxContainer/Label

var _allowed_binding_types := []
var _current_action: InputSettingsActionWrapper


func _ready():
	size = min_size

func remap_input(action: InputSettingsActionWrapper) -> void:
	if visible:
		return
	_current_action = action
	title = "Remap %s" % action.get_display_name()
	_allowed_binding_types = InputMapMgr.bindings_column_types[action.binding_index]
	_init_label()
	set_process_input(true)
	popup_centered()


func _init_label() -> void:
	var msg := "Press "
	var types_count = _allowed_binding_types.size()
	for i in types_count:
		if i > 0 and i == types_count - 1:
			msg += " or "
		elif i > 0:
			msg += ", "
		msg += BINDINGS_TYPE_TO_MESSAGE_NAME[_allowed_binding_types[i]]
	_label.text = msg


func _input(event: InputEvent) -> void:
	if !event.is_pressed():
		return
	var event_class:String = event.get_class()
	if !_allowed_binding_types.has(event_class):
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
