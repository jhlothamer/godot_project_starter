extends Control

@onready var _exit_btn:Button = $ButtonsMarginContainer/VBoxContainer/ExitBtn
@onready var _title_lbl: Label = $TitleMarginContainer/TitleLbl

func _ready():
	_title_lbl.text = ProjectSettings.get_setting("application/config/name")
	if OS.get_name() == "Web":
		_exit_btn.visible = false


func _on_ExitBtn_pressed():
	get_tree().quit()

