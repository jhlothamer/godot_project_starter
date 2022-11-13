extends Control

@onready var _retry_btn: Button = $VBoxContainer/RetryBtn

func _ready():
	visible = false


func _input(event):
	if event.is_echo():
		return
	if event.is_action_pressed("game_over"):
		visible = true
		get_tree().paused = true
		_retry_btn.grab_focus()
