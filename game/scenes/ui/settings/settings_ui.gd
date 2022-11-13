extends VBoxContainer

signal help_message_changed(message)

const HELP_MESSAGE = "Use %%prompt:pad:previous_settings_tab%% or %%prompt:pad:next_settings_tab%% to switch tabs"

@onready var _tabs:TabBar = $TabContainer/TabBar
@onready var _tab_panels = $TabPanelContainer.get_children()
@onready var _settings_ui :=[
	$TabPanelContainer/Volume/MarginContainer/VolumeSettingsUI,
	$TabPanelContainer/Controls/ControlSettingsUI
]


var _allow_prev_next_tab := true
var _game_pad_device_id: int = -1

func _ready():
	_init_prev_next_tab()
	for tab_panel in _tab_panels:
		_tabs.add_tab(tab_panel.name)
	_on_Tabs_tab_changed(0)


func _on_Tabs_tab_changed(tab: int) -> void:
	for i in _tab_panels.size():
		_tab_panels[i].visible = i == tab
		if tab == i:
			var _discard = _set_focus(_tab_panels[i])


func _on_PreviousTabBtn_pressed():
		var tab = _tabs.current_tab - 1
		if tab < 0:
			tab = _tabs.get_tab_count() - 1
		_tabs.current_tab = tab


func _on_NextTabBtn_pressed():
	_tabs.current_tab = (_tabs.current_tab + 1) % _tabs.get_tab_count()


func _set_focus(ctrl: Control) -> bool:
	if !ctrl.visible:
		return false
	if ctrl is Button or ctrl is HSlider:
		ctrl.grab_focus()
		return true
	
	for child in ctrl.get_children():
		if _set_focus(child):
			return true
	
	return false


func _input(event):
	if event.is_action_pressed("next_settings_tab") and _allow_prev_next_tab:
		_on_NextTabBtn_pressed()
	elif event.is_action_pressed("previous_settings_tab") and _allow_prev_next_tab:
		_on_PreviousTabBtn_pressed()



func _on_ControlSettings_remap_started():
	_allow_prev_next_tab = false


func _on_ControlSettings_remap_ended():
	_allow_prev_next_tab = true


func validate() -> String:
	for settings in _settings_ui:
		if settings.has_method("validate"):
			var error_msg:String = settings.validate()
			if !error_msg.is_empty():
				return error_msg
	return ""


func reset() -> void:
	for settings in _settings_ui:
		if settings.has_method("reset"):
			settings.reset()


func save() -> void:
	for settings in _settings_ui:
		if settings.has_method("save"):
			settings.save()


func cancel() -> void:
	for settings in _settings_ui:
		if settings.has_method("cancel"):
			settings.cancel()

func _init_prev_next_tab() -> void:
	if !InputMap.has_action("next_settings_tab") or !InputMap.has_action("previous_settings_tab"):
		return
	for event in InputMap.action_get_events("next_settings_tab"):
		if event is InputEventJoypadButton:
			_game_pad_device_id = event.device
	for event in InputMap.action_get_events("previous_settings_tab"):
		if event is InputEventJoypadButton:
			if _game_pad_device_id != event.device:
				_game_pad_device_id = -1
				return
	call_deferred("_on_joy_connection_changed",_game_pad_device_id, Input.is_joy_known(_game_pad_device_id))
	
	if OK != Input.connect("joy_connection_changed",Callable(self,"_on_joy_connection_changed")):
		printerr("SettingsUI: can't connect to joy_connection_changed signal")


func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if _game_pad_device_id != device:
		return
	if !connected:
		emit_signal("help_message_changed", "")
		return
	emit_signal("help_message_changed", InputPromptUtil.replace_input_prompts(HELP_MESSAGE, true))

func re_init() -> void:
	_tabs.current_tab = 0
	_on_Tabs_tab_changed(0)
	for settings in _settings_ui:
		if settings.has_method("init"):
			settings.init()
