extends Control


@onready var _retry_btn: Button = $VBoxContainer/RetryBtn


func _ready():
	visible = false
	EventBus.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	visible = true
	get_tree().paused = true
	_retry_btn.grab_focus()


func _on_retry_btn_pressed() -> void:
	TransitionMgr.transition_to(get_tree().current_scene.scene_file_path)
