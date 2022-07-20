extends Control

onready var _settings_ui = $MarginContainer/VBoxContainer/SettingsUI
onready var _validation_msg_lbl: Label = $MarginContainer/VBoxContainer/HeaderHBoxContainer/ValidationMessageLbl
onready var _help_msg_lbl: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/HelpMessageContainer/HelpMessageLbl

func _on_ResetBtn_pressed():
	_settings_ui.reset()
	_validation_msg_lbl.text = ""


func _on_CancelBtn_about_to_transition():
	_settings_ui.cancel()


func save() -> bool:
	var validation_msg = _settings_ui.validate()
	if !validation_msg.empty():
		_validation_msg_lbl.text = validation_msg
		return false
	
	_validation_msg_lbl.text = ""
	
	_settings_ui.save()
	return true


func _on_SettingsUI_help_message_changed(message: String) -> void:
	_help_msg_lbl.bbcode_text = "[center]%s[/center]" % message

