class_name InputEventDisplayNameUtil
extends Object

const MOUSE_BUTTON_TEXT := [
	"Invalid!",
	"Left Button",
	"Right Button",
	"Middle Button",
	"Wheel Up",
	"Wheel Down",
	"Wheel Left",
	"Wheel Right",
	"X Button 1",
	"X Button 2",
]


const JOY_BUTTON_TEXT := [
"A",
"B",
"X",
"Y",
"Back",
"Home",
"Start",
"L/LS",
"R/RS",
"LB",
"RB",
"D-pad Up",
"D-pad Down",
"D-pad Left",
"D-pad Right",
"Share",
"Paddle 1",
"Paddle 2",
"Paddle 3",
"Paddle 4",
"Touchpad",
]


static func get_display_name(event: InputEvent) -> String:
	if event is InputEventKey:
		var ek := event as InputEventKey
		var s = OS.get_keycode_string(ek.get_physical_keycode_with_modifiers()) if ek.keycode == 0 else OS.get_keycode_string(ek.get_keycode_with_modifiers())
		return s
	elif event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		return MOUSE_BUTTON_TEXT[mb.button_index]
	elif event is InputEventJoypadButton:
		var jb: InputEventJoypadButton = event
		return JOY_BUTTON_TEXT[jb.button_index]
	else:
		printerr("Could not generate display name for type %s" % event.get_class())

	return "??"


