class_name InputSettingsCategory
extends RefCounted


var name := ""
var actions := []

func apply() -> void:
	for action in actions:
		action.apply()

func duplicate():
	var dup = get_script().new()
	dup.name = name
	for action in actions:
		dup.actions.append(action.duplicate())
	return dup
