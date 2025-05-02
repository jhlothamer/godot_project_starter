## a RichTextLabel that will load a file for text.
class_name FileContentRichTextLabel
extends RichTextLabel


## text file to display
@export_file("*.txt") var file_path := ""
## handles meta clicks that are URLs
@export var open_urls_in_browser := true
## only https URLs opened (if off, also allows http URLs)
@export var https_only := true


func _ready():
	text = FileAccess.get_file_as_string(file_path)
	if open_urls_in_browser:
		meta_clicked.connect(_on_meta_clicked)


func _on_meta_clicked(meta: Variant) -> void:
	if typeof(meta) != TYPE_STRING: return
	var meta_string := str(meta).strip_edges()
	var lower_meta_string := meta_string.to_lower()
	if not lower_meta_string.begins_with("http"): return
	if https_only and not lower_meta_string.begins_with("https"): return
	OS.shell_open(str(meta_string))
