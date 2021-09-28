extends Control

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


func _on_Resume_pressed():
		visible = false
		get_tree().paused = false
