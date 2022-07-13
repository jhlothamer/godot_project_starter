class_name InputSettingsCategory
extends Reference


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
