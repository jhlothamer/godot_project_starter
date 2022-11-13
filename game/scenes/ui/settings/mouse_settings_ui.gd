
extends VBoxContainer

@onready var _invert_y_chk_btn: CheckButton = $HBoxContainer/GridContainer/HBoxContainer/InvertMouseChkBtn
@onready var _sensitivity_slider: HSlider = $HBoxContainer/GridContainer/SensitivtyHSlider

var _mouse_settings: InputMouseSettings

func init(mouse_settings: InputMouseSettings) -> void:
	_mouse_settings = mouse_settings
	if !mouse_settings.show:
		visible = false
		return
	visible = true
	_sensitivity_slider.max_value = mouse_settings.sensitivity_max
	_sensitivity_slider.min_value = mouse_settings.sensitivity_min
	_sensitivity_slider.value = mouse_settings.sensitivity
	_invert_y_chk_btn.button_pressed = mouse_settings.invert_y



func _on_InvertMouseChkBtn_toggled(button_pressed: bool) -> void:
	_mouse_settings.invert_y = button_pressed


func _on_SensitivtyHSlider_value_changed(value: float) -> void:
	_mouse_settings.sensitivity = value
