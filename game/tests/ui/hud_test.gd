extends Control


func _on_SimulateGameOverBtn_pressed():
	EventBus.game_over.emit()
