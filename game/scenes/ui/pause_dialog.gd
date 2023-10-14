extends Control

@onready var _resume_btn: Button = $VBoxContainer/ResumeBtn
@onready var _to_show_hide := [
	$DialogBackground,
	$VBoxContainer
]
@onready var _settings_dialog = $SettingsDialog

func _ready():
	visible = false
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("pause") and !_settings_dialog.visible:
		if visible:
			visible = false
			get_tree().paused = false
			process_mode = Node.PROCESS_MODE_PAUSABLE
		else:
			visible = true
			process_mode = Node.PROCESS_MODE_ALWAYS
			get_tree().paused = true
			_resume_btn.grab_focus()


func _on_ResumeBtn_pressed():
		visible = false
		get_tree().paused = false


func _on_Settingsbtn_pressed():
	for c in _to_show_hide:
		c.visible = false
	_settings_dialog.show()
	await _settings_dialog.dismissed
	for c in _to_show_hide:
		c.visible = true
	_resume_btn.grab_focus()

