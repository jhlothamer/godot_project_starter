extends Control

onready var _resume_btn: Button = $VBoxContainer/ResumeBtn
onready var _to_show_hide := [
	$DialogBackground,
	$VBoxContainer
]
onready var _settings_dialog = $SettingsDialog

func _ready():
	visible = false

func _input(event):
	if event.is_echo():
		return
	if event.is_action_pressed("pause"):
		if visible:
			visible = false
			get_tree().paused = false
			pause_mode = Node.PAUSE_MODE_STOP
		else:
			visible = true
			pause_mode = Node.PAUSE_MODE_PROCESS
			get_tree().paused = true
			_resume_btn.grab_focus()



func _on_ResumeBtn_pressed():
		visible = false
		get_tree().paused = false


func _on_Settingsbtn_pressed():
	for c in _to_show_hide:
		c.visible = false
	_settings_dialog.show()
	yield(_settings_dialog, "dismissed")
	for c in _to_show_hide:
		c.visible = true
	_resume_btn.grab_focus()

