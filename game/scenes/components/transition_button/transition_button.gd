class_name TransitionButton
extends Button

export (String, FILE, "*.tscn,*.scn,*.res") var scene_to_load := ""
export (float) var transition_speed_seconds := -1.0
export (bool) var fade_sound := false

func _on_Button_pressed():
	if scene_to_load == null || scene_to_load == "":
		return
	
	TransitionMgr.transition_to(scene_to_load, transition_speed_seconds, fade_sound)


