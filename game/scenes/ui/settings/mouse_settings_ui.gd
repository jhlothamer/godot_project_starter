extends VBoxContainer


@onready var _invert_y_chk_btn: CheckButton = %InvertMouseChkBtn
@onready var _sensitivity_slider: HSlider = %SensitivtyHSlider


var _mouse_settings: InputMouseSettings
var _initialiting := false


func init(mouse_settings: InputMouseSettings) -> void:
	_initialiting = true
	_mouse_settings = mouse_settings
	if !mouse_settings.show:
		visible = false
		return
	visible = true
	_sensitivity_slider.max_value = mouse_settings.sensitivity_max
	_sensitivity_slider.min_value = mouse_settings.sensitivity_min
	_sensitivity_slider.value = mouse_settings.sensitivity
	_invert_y_chk_btn.button_pressed = mouse_settings.invert_y
	_initialiting = false


func reset() -> void:
	if !visible: return
	_sensitivity_slider.value = _mouse_settings.default_sensitivity
	_invert_y_chk_btn.button_pressed = _mouse_settings.default_invert_y


func _on_InvertMouseChkBtn_toggled(button_pressed: bool) -> void:
	if _initialiting: return
	_mouse_settings.invert_y = button_pressed


func _on_SensitivtyHSlider_value_changed(value: float) -> void:
	if _initialiting: return
	_mouse_settings.sensitivity = value
