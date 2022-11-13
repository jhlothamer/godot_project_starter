extends Control



@onready var _cover_control := $Cover
@onready var _start_stop_screenshots_btn := $MarginContainer/VBoxContainer/StartStopScreenShotsBtn
@onready var _frame_delay_spin: SpinBox = $MarginContainer/VBoxContainer/FrameDelayHBoxContainer/FrameDelaySpin
@onready var _resize_factor_spin: SpinBox = $MarginContainer/VBoxContainer/ResizeFactorHBoxContainer/ResizeFactorSpin
@onready var _status_text: TextEdit = $MarginContainer/VBoxContainer/StatusText
@onready var _user_data_dir := OS.get_user_data_dir()
@onready var _path_separator := "\\" if _user_data_dir.find("\\") > -1 else "/"

var _capture := false
var _frame_counter := 0
var _directory_name := ""
var _file_counter := 0
var _crop_size: Vector2
var _user_data_directory:DirAccess
var _threads := []
var _frame_delay := .1
var _resize_factor := .5
var _time_since_last_frame := 0.0
var _stopwatch := Stopwatch.new()


func _ready():
	_user_data_directory = DirAccess.open("user://")
	_crop_size = _cover_control.size
	var temp = ProjectSettings.get_setting("global/screenshot_mgr_frame_delay")
	if temp:
		_frame_delay_spin.value = temp
	_frame_delay = _frame_delay_spin.value
	temp = ProjectSettings.get_setting("global/screenshot_mgr_resize_factor")
	if temp and temp > 0.0:
		_resize_factor_spin.value = temp
	_resize_factor = _resize_factor_spin.value


func get_date_time_string():
	# year, month, day, weekday, dst (daylight savings time), hour, minute, second.
	var datetime = Time.get_datetime_dict_from_system()
	return "%d%02d%02d_%02d%02d%02d" % [datetime["year"], datetime["month"], datetime["day"], datetime["hour"], datetime["minute"], datetime["second"]]


func _on_SingleScreenShotBtn_pressed():
	_directory_name = get_date_time_string()
	_user_data_directory.make_dir(_directory_name)
	_take_screen_shot()
	_status_text.text = "Single screenshot saved to:\r\n%s%s%s\r\nReady" % [_user_data_dir, _path_separator, _directory_name]


func _on_StartStopScreenShotsBtn_pressed():
	if !_capture:
		_capture = true
		_frame_counter = 0
		_file_counter = 0
		_start_stop_screenshots_btn.text = "Stop Capturing Screen Shots"
		_directory_name = get_date_time_string()
		_user_data_directory.make_dir(_directory_name)
		_status_text.text = "Screenshots started.\r\nSaving to %s%s%s" % [_user_data_dir, _path_separator, _directory_name]
		_stopwatch.start()
	else:
		_capture = false
		_stopwatch.stop()
		_start_stop_screenshots_btn.text = "Start Capturing Screen Shots"
		var seconds = _stopwatch.get_elapsed_msec() / 1000.0
		_status_text.text += "\r\nScreenshots stopped.  # of files: %d, elapsed seconds: %f" % [_file_counter, seconds]
		_status_text.text += "\r\nReady"


func _physics_process(delta):
	if !_capture:
		return
	_time_since_last_frame += delta
	if _time_since_last_frame < _frame_delay:
		return
	_time_since_last_frame -= _frame_delay
	
	#var take_image := _frame_counter % frame_to_drop != 0
	
	_frame_counter += 1
#	if !take_image:
#		return
	
	_take_screen_shot()
	
	_file_counter += 1
	

func _take_screen_shot():
	var image: Image = get_viewport().get_texture().get_image()
	var thread := Thread.new()
	_threads.append(thread)
	thread.start(Callable(self,"_save_image").bind([image, thread]))


func _save_image(data: Array) -> void:
	var image: Image = data[0]
	if _resize_factor != 1.0:
		var original_size = image.get_size()
		image.resize(original_size.x*_resize_factor, original_size.y*_resize_factor, Image.INTERPOLATE_BILINEAR)
	image.crop(int(_crop_size.x*_resize_factor), int(_crop_size.y*_resize_factor))
	var error = image.save_png("user://%s/%04d.png" % [_directory_name, _file_counter])
	if error != OK:
		printerr("CoverImageGenerator: error while saving image %d" % error)
	_threads.erase(data[1])


func _on_FrameDelaySpin_value_changed(value):
	_frame_delay = value


func _on_ResizeFactorSpin_value_changed(value):
	_resize_factor = value
