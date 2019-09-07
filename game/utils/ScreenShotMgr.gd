extends Node

export (int, 1, 100000) var screenshot_max : int = 1000
export (float, 0.0, 2.0) var resize_factor : float = 1.0
export var enabled : bool
export var screenshot_action_name : String = "screen_shot"

var allow_input : bool = true
var take_screenshots : bool = false
var directory_name : String = ""
var file_counter : int = 0
var user_data_directory : Directory = Directory.new()

func _ready():
	user_data_directory.open("user://")

func _input(event):
	if !allow_input || !Input.is_action_just_pressed(screenshot_action_name):
		return
	allow_input = false
	$inputDebounceTimer.start()
	take_screenshots = !take_screenshots
	if take_screenshots:
		directory_name = get_date_time_string()
		file_counter = 0
		user_data_directory.make_dir(directory_name)
		print("starting screenshots")
	else:
		print("stopping screenshots with " + String(file_counter) + " shots taken.")

func _on_inputDebounceTimer_timeout():
	allow_input = true

func get_date_time_string():
	# year, month, day, weekday, dst (daylight savings time), hour, minute, second.
	var datetime = OS.get_datetime()
	return String(datetime["year"]) + i_to_padded(datetime["month"],2) + i_to_padded(datetime["day"],2) + "_" + i_to_padded(datetime["hour"],2) + i_to_padded(datetime["minute"],2) + i_to_padded(datetime["second"],2)

func i_to_padded(i : int, digits: int) -> String:
	return String(i).pad_zeros(digits)


func _process(delta):
	if !take_screenshots:
		return
	if file_counter >= screenshot_max:
		take_screenshots = false
		print("Max screenshots reached.  Stopping screenshots with " + String(file_counter) + " shots taken.")	
		return

	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	if resize_factor != 1.0:
		var original_size = image.get_size()
		image.resize(original_size.x*resize_factor, original_size.y*resize_factor, Image.INTERPOLATE_BILINEAR)
	image.save_png("user://" + directory_name + "/" + i_to_padded(file_counter,4) + ".png")
	file_counter += 1
