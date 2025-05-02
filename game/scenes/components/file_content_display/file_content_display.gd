extends TextEdit

@export_file("*.txt") var file_path := ""


func _ready():
	text = FileAccess.get_file_as_string(file_path)
