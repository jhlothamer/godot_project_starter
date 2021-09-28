extends Control


func _ready():
	visible = false


func _input(event):
	if event.is_echo():
		return
	if event.is_action_pressed("game_over"):
		visible = true
		get_tree().paused = true
