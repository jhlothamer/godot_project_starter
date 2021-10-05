class_name Stopwatch
extends Reference

var _start_time : float
var _stop_time : float


# start stop watch
func start():
	_start_time = OS.get_ticks_usec()
	_stop_time = _start_time


# stop stop watch
func stop():
	_stop_time = OS.get_ticks_usec()


# gets elapsed microseconds
func get_elapsed_usec():
	return _stop_time - _start_time


# gets elapsed milliseconds
func get_elapsed_msec():
	return get_elapsed_usec() / 1000.0
