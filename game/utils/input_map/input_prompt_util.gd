class_name InputPromptUtil
extends Object

const PROMPT_REGEX = "%%prompt:(?<input_type>\\w+):(?<action_name>\\w+)%%"
const KEY_MOUSE_PROMPT_IMAGE_FILE_PATH = "res://assets/images/ui/input_prompts/xelu_free_keyboardcontroller_prompts_pack/Keyboard & Mouse/Light3D/%s_Key_Light.png"
const PAD_PROMPT_IMAGE_FILE_PATH = "res://assets/images/ui/input_prompts/xelu_free_keyboardcontroller_prompts_pack/Others/Xbox 360/360_%s.png"
const SMALL_KEY_MOUSE_PROMPT_IMAGE_FILE_PATH = "res://assets/images/ui/input_prompts/xelu_free_keyboardcontroller_prompts_pack/Keyboard & Mouse/Light3D/small_%s_Key_Light.png"
const SMALL_PAD_PROMPT_IMAGE_FILE_PATH = "res://assets/images/ui/input_prompts/xelu_free_keyboardcontroller_prompts_pack/Others/Xbox 360/small_360_%s.png"

const JOY_BUTTON_IMG_SUFIX := [
	"A",
	"B",
	"X",
	"Y",
	"Back",
	"Home",
	"Start",
	"Right_Stick_Click",
	"Left_Stick_Click",
	"LB",
	"RB",
	"Dpad_Up",
	"Dpad_Down",
	"Dpad_Left",
	"Dpad_Right",
	"Share",
	"Paddle 1",
	"Paddle 2",
	"Paddle 3",
	"Paddle 4",
	"TouchPad"
]

const KEY_IMG_FILE_SUFFIXES := {
	KEY_QUOTELEFT: "Tilda",
	KEY_EQUAL: "Plus",
	KEY_BACKSPACE: "Backspace",
	KEY_BRACKETLEFT: "Bracket_Left",
	KEY_BRACKETRIGHT: "Bracket_Right",
	KEY_BACKSLASH: "Slash",
	KEY_CAPSLOCK: "Caps_Lock",
	KEY_APOSTROPHE: "Quote",
	KEY_COMMA: "Mark_Left",
	KEY_PERIOD: "Mark_Right",
	KEY_CTRL: "Ctrl",
	KEY_PAGEUP: "Page_Up",
	KEY_DELETE: "Del",
	KEY_PAGEDOWN: "Page_Down",
	KEY_UP: "Arrow_Up",
	KEY_DOWN: "Arrow_Down",
	KEY_LEFT: "Arrow_Left",
	KEY_RIGHT: "Arrow_Right",
	KEY_NUMLOCK: "Num_Lock",
	KEY_KP_DIVIDE: "Divide",
	KEY_KP_MULTIPLY: "Asterisk",
	KEY_KP_SUBTRACT: "Minus",
	KEY_KP_ADD: "Plus_Tall",
	KEY_KP_ENTER: "Enter_Tall",
	KEY_KP_0: "0",
	KEY_KP_1: "1",
	KEY_KP_2: "2",
	KEY_KP_3: "3",
	KEY_KP_4: "4",
	KEY_KP_5: "5",
	KEY_KP_6: "6",
	KEY_KP_7: "7",
	KEY_KP_8: "8",
	KEY_KP_9: "9",
	KEY_KP_PERIOD: "Del",
}

static func replace_input_prompts(s: String, small: bool = false) -> String:
	var regex = RegEx.new()
	regex.compile(PROMPT_REGEX)
	
	for i in regex.search_all(s):
		var m: RegExMatch = i
		if m.strings.size() != 3:
			printerr("InputPromptUtil: did not find proper prompt in string??  skipping.")
			continue
		var input_event = _get_action_input(m.strings[1], m.strings[2])
		if input_event == null:
			continue
		var image_path := get_input_event_image_file_path(input_event, small)
		if !image_path.is_empty():
			s = s.replace(m.strings[0], "[img]%s[/img]" % image_path)
			continue
		var display_text = InputEventDisplayNameUtil.get_display_name(input_event)
		s = s.replace(m.strings[0], display_text)
	
	return s

static func _get_action_input(input_type: String, action_name: String) -> InputEvent:
	for a in InputMap.action_get_events(action_name):
		if a is InputEventKey and input_type == "key":
			return a
		if a is InputEventJoypadButton and input_type == "pad":
			return a
		if a is InputEventMouseButton and input_type == "mouse":
			return a
	
	printerr("InputPromptUtil: did not find event for action %s of type %s" % [action_name, input_type])

	return null

static func get_input_event_image_file_path(input_event: InputEvent, small: bool) -> String:
	if input_event is InputEventKey:
		return _get_input_event_image_file_path_key(input_event, small)
	if input_event is InputEventMouseButton:
		return _get_input_event_image_file_path_mouse(input_event, small)
	if input_event is InputEventJoypadButton:
		return _get_input_event_image_file_path_pad(input_event, small)
	
	return ""


static func _get_input_event_image_file_path_key(ek: InputEventKey, small: bool) -> String:
	var s = OS.get_keycode_string(ek.get_physical_keycode_with_modifiers()) if ek.keycode == 0 else OS.get_keycode_string(ek.get_keycode_with_modifiers())
	var img_path = KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % s if !small else SMALL_KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % s
	if ResourceLoader.exists(img_path):
		return img_path
	if KEY_IMG_FILE_SUFFIXES.has(ek.keycode):
		img_path = KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % KEY_IMG_FILE_SUFFIXES[ek.keycode]
		if ResourceLoader.exists(img_path):
			return img_path
	#return InputEventDisplayNameUtil.get_display_name(ek)
	return ""

static func _get_input_event_image_file_path_mouse(emb: InputEventMouseButton, small: bool) -> String:
	match emb.button_index:
		MOUSE_BUTTON_LEFT:
			return KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % "Mouse_Left" if !small else SMALL_KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % "Mouse_Left"
		MOUSE_BUTTON_RIGHT:
			return KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % "Mouse_Right" if !small else SMALL_KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % "Mouse_Right"
		MOUSE_BUTTON_MIDDLE:
			return KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % "Mouse_Middle" if !small else SMALL_KEY_MOUSE_PROMPT_IMAGE_FILE_PATH % "Mouse_Middle"
	return ""

static func _get_input_event_image_file_path_pad(ejb: InputEventJoypadButton, small: bool) -> String:
	var s = JOY_BUTTON_IMG_SUFIX[ejb.button_index]
	var img_path = PAD_PROMPT_IMAGE_FILE_PATH % s if !small else SMALL_PAD_PROMPT_IMAGE_FILE_PATH % s
	if ResourceLoader.exists(img_path):
		return img_path
	return ""



