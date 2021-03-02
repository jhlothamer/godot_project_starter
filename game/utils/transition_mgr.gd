extends CanvasLayer

onready var _starting_bus_volume = AudioServer.get_bus_volume_db(0)


var _for_anim_db = 1.0 setget set_for_anim_db
var _scene_path := ""
var _animation_speed := 1.0
var _do_volume_anim := false
var _mute_bus_volume := -80.0


func set_for_anim_db(value: float) -> void:
	_for_anim_db = value
	if _do_volume_anim:
		AudioServer.set_bus_volume_db(0, _mute_bus_volume - _for_anim_db*(_mute_bus_volume - _starting_bus_volume))


func transition_to(scene_path, speed_seconds = 1.0, include_sound = false):
	_scene_path = scene_path
	_animation_speed = 2.0 / speed_seconds
	_do_volume_anim = include_sound
	$fadeAnimation.play("fadeOut", -1, _animation_speed)


func _on_fadeAnimation_animation_finished(anim_name):
	if anim_name == "fadeOut":
		var results = get_tree().change_scene(_scene_path)
		if results != OK:
			printerr("TransitionMgr: could not change to scene '%s'" % _scene_path)
			return
		get_tree().paused = false
		$fadeAnimation.play("fadeIn", -1, _animation_speed)

