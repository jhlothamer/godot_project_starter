extends Control

export var frame_to_drop := 8
export (float, 0.0, 2.0) var resize_factor : float = .5


onready var _cover_control := $Cover
onready var _start_stop_screenshots_btn := $VBoxContainer/StartStopScreenShotsBtn


var _capture := false
var _frame_counter := 0
var _directory_name := ""
var _file_counter := 0
var _crop_size: Vector2

var _user_data_directory: Directory = Directory.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_user_data_directory.open("user://")
	_crop_size = _cover_control.rect_size


func get_date_time_string():
	# year, month, day, weekday, dst (daylight savings time), hour, minute, second.
	var datetime = OS.get_datetime()
	return String(datetime["year"]) + i_to_padded(datetime["month"],2) + i_to_padded(datetime["day"],2) + "_" + i_to_padded(datetime["hour"],2) + i_to_padded(datetime["minute"],2) + i_to_padded(datetime["second"],2)


func i_to_padded(i : int, digits: int) -> String:
	return String(i).pad_zeros(digits)


func _on_SingleScreenShotBtn_pressed():
	_directory_name = get_date_time_string()
	_user_data_directory.make_dir(_directory_name)
	_take_screen_shot()
	print("Screen shot taken saved in %s" % _directory_name)


func _on_StartStopScreenShotsBtn_pressed():
	if !_capture:
		_capture = true
		_frame_counter = 0
		_file_counter = 0
		_start_stop_screenshots_btn.text = "Stop Capturing Screen Shots"
		_directory_name = get_date_time_string()
		_user_data_directory.make_dir(_directory_name)
	else:
		_capture = false
		_start_stop_screenshots_btn.text = "Start Capturing Screen Shots"
		print("%d screen shots taken and saved in %s" %[ _file_counter, _directory_name])


func _process(delta):
	if !_capture:
		return
	
	var take_image := _frame_counter % frame_to_drop != 0
	
	_frame_counter += 1
	if !take_image:
		return
	
	_take_screen_shot()
	
	_file_counter += 1
	

func _take_screen_shot():
	var image: Image = get_viewport().get_texture().get_data()
	image.flip_y()
	if resize_factor != 1.0:
		var original_size = image.get_size()
		image.resize(original_size.x*resize_factor, original_size.y*resize_factor, Image.INTERPOLATE_BILINEAR)
	image.crop(_crop_size.x*resize_factor, _crop_size.y*resize_factor)
	image.save_png("user://" + _directory_name + "/" + i_to_padded(_file_counter,4) + ".png")
