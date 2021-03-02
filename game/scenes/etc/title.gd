extends TextureRect

onready var exit_btn := $VBoxContainer/exitBtn

func _ready():
	$TitleLbl.text = ProjectSettings.get_setting("application/config/name")
	if OS.get_name() == "HTML5":
		exit_btn.visible = false

func _on_exitBtn_pressed():
	get_tree().quit()

