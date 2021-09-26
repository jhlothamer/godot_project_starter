extends Node

var _screenshot_max : int = 1000
var _resize_factor : float = 1.0
var _screenshot_action_name : String = "toggle_screenshots"
var _directory_name := ""
var _file_counter := 0
var _user_data_directory : Directory = Directory.new()
var _threads := []


func _ready():
	if !OS.has_feature("debug"):
		queue_free()
		return
	set_process(false)
	_user_data_directory.open("user://")
	_init_settings()

func _init_settings():
	var temp = ProjectSettings.get_setting("global/screenshot_mgr_max_images")
	if temp and temp > 0:
		_screenshot_max = temp
	
	temp = ProjectSettings.get_setting("global/screenshot_mgr_resize_factor")
	if temp and temp > 0.0:
		_resize_factor = temp

	temp = ProjectSettings.get_setting("global/screenshot_mgr_toggle_action_name")
	if temp:
		_screenshot_action_name = temp


func _input(event):
	if !event.is_action_pressed(_screenshot_action_name) or event.is_echo():
		return
	if !is_processing():
		_directory_name = get_date_time_string()
		_file_counter = 0
		_user_data_directory.make_dir(_directory_name)
		print("starting screenshots")
		set_process(true)
	else:
		print("stopping screenshots with %d shots taken." % _file_counter)
		set_process(false)


func get_date_time_string():
	# year, month, day, weekday, dst (daylight savings time), hour, minute, second.
	var datetime = OS.get_datetime()
	return "%d%02d%02d_%02d%02d%02d" % [datetime["year"], datetime["month"], datetime["day"], datetime["hour"], datetime["minute"], datetime["second"]]


func _process(delta):
	if _file_counter >= _screenshot_max:
		print("Max screenshots reached.  Stopping screenshots with %d shots taken." % _file_counter)
		set_process(false)
		return

	var image = get_viewport().get_texture().get_data()
	var thread := Thread.new()
	_threads.append(thread)
	thread.start(self, "_save_image", [image, thread])
	_file_counter += 1


func _save_image(data: Array) -> void:
	var image: Image = data[0]
	image.flip_y()
	if _resize_factor != 1.0:
		var original_size = image.get_size()
		image.resize(original_size.x*_resize_factor, original_size.y*_resize_factor, Image.INTERPOLATE_BILINEAR)
	var error = image.save_png("user://%s/%04d.png" % [_directory_name, _file_counter])
	if error != OK:
		printerr("ScreenshotMgr: error while saving image %d" % error)
	_threads.erase(data[1])
