extends TextEdit

@export_file("*.txt") var file_path := ""

func _ready():
	text = readFile()

func readFile():
	if file_path == "" || file_path == null:
		return ""
	if !FileAccess.file_exists(file_path):
		return "file does not exist: '%s'" % file_path
	var f = FileAccess.open(file_path, FileAccess.READ)
	return f.get_as_text()
