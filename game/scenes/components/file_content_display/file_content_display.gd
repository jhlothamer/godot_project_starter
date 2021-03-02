extends TextEdit

export (String, FILE) var file_path := ""

func _ready():
	text = readFile()

func readFile():
	if file_path == "" || file_path == null:
		return ""
	var f = File.new()
	if !f.file_exists(file_path):
		return "file does not exist: '%s'" % file_path
	f.open(file_path, File.READ)
	var text = f.get_as_text()
	f.close()
	return text
