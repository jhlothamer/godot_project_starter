## mouse settings configuration
class_name InputMapMouseSettingsCfg
extends Resource

## determines if mouse settings even appear in settings menu
@export var show_mouse_settings := true
## default value for invert y option
@export var default_invert_y := false
## mouse sensativity minimum value
@export_range(.1, 1.0, .1) var sensitivity_min := .5
## mouse sensativity maximum value
@export_range(1.0, 4.0, .1) var sensitivity_max := 2.5
## mouse sensativity default value
@export_range(.1, 4.0, .1) var sensitivity_default := 1.5

