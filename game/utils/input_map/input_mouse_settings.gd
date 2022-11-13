class_name InputMouseSettings
extends RefCounted

var show := false
var invert_y := false
var default_invert_y := false
var sensitivity_min := .5
var sensitivity_max := .5
var sensitivity := 1.0
var default_sensitivity := 1.0

func _init(data: Dictionary):
	if data.is_empty():
		return
	show = data["show"]
	default_invert_y = data["default_invert_y"]
	invert_y = default_invert_y
	sensitivity_min = data["sensitivity"]["min"]
	sensitivity_max = data["sensitivity"]["max"]
	default_sensitivity = data["sensitivity"]["default"]
	default_sensitivity = clamp(default_sensitivity, sensitivity_min, sensitivity_max)
	sensitivity = default_sensitivity

func reset() -> void:
	invert_y = default_invert_y
	sensitivity = default_sensitivity

func load_data(data: Dictionary) -> void:
	if data.has("mouse_invert_y"):
		invert_y = data["mouse_invert_y"]
	if data.has("mouse_sensitivity"):
		sensitivity = data["mouse_sensitivity"]


func save_data(data: Dictionary) -> void:
	data["mouse_invert_y"] = invert_y
	data["mouse_sensitivity"] = sensitivity


func duplicate():
	var dup = get_script().new({})
	dup.show = show
	dup.default_invert_y = default_invert_y
	dup.invert_y = invert_y
	dup.sensitivity_min = sensitivity_min
	dup.sensitivity_max = sensitivity_max
	dup.default_sensitivity = default_sensitivity
	dup.sensitivity = sensitivity
	return dup

