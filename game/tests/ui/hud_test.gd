extends Control


func _on_SimulateGameOverBtn_pressed():
	var a = InputEventAction.new()
	a.action = "game_over"
	a.pressed = true
	Input.parse_input_event(a)

