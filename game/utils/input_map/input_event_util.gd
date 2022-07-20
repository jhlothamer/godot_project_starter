class_name InputEventUtil
extends Object


static func duplicate_event(event: InputEvent) -> InputEvent:
	if event is InputEventKey:
		var dup := InputEventKey.new()
		dup.scancode = event.scancode
		dup.physical_scancode = event.physical_scancode
		return dup
	if event is InputEventJoypadButton:
		var dup := InputEventJoypadButton.new()
		dup.button_index = event.button_index
		return dup
	if event is InputEventMouseButton:
		var dup := InputEventMouseButton.new()
		dup.button_index = event.button_index
		return dup
	printerr("InputSettingsAction: could not duplicate event of type %s" % event.get_class())
	assert(false)
	return event


static func duplicate_events(events: Array) -> Array:
	var duped_events := []
	for event in events:
		if !event:
			duped_events.append(null)
			continue
		duped_events.append(duplicate_event(event))
	return duped_events


static func deserialize_input_events(serialized_input_events: Array) -> Array:
	var events := []
	for i in serialized_input_events:
		var serialized_input_event: Dictionary = i
		var event: InputEvent
		var type:String = serialized_input_event["type"]
		match(type):
			"InputEventKey":
				var ek := InputEventKey.new()
				ek.scancode = serialized_input_event["scancode"]
				ek.physical_scancode = serialized_input_event["physical_scancode"]
				event = ek
			"InputEventMouseButton":
				var mb := InputEventMouseButton.new()
				mb.button_index = serialized_input_event["button_index"]
				event = mb
			"InputEventJoypadButton":
				var jb := InputEventJoypadButton.new()
				jb.button_index = serialized_input_event["button_index"]
				event = jb
		events.append(event)
	return events


static func serialize_input_events(input_events: Array) -> Array:
	var serialized_input_events := []
	for i in input_events:
		var event_data := {}
		if i is InputEventKey:
			var ek: InputEventKey = i
			event_data["type"] = "InputEventKey"
			event_data["scancode"] = ek.scancode
			event_data["physical_scancode"] = ek.physical_scancode
		elif i is InputEventMouseButton:
			var mb: InputEventMouseButton = i
			event_data["type"] = "InputEventMouseButton"
			event_data["button_index"] = mb.button_index
		elif i is InputEventJoypadButton:
			var jb: InputEventJoypadButton = i
			event_data["type"] = "InputEventJoypadButton"
			event_data["button_index"] = jb.button_index
		event_data["display_name"] = InputEventDisplayNameUtil.get_display_name(i)
		serialized_input_events.append(event_data)

	return serialized_input_events


static func are_events_same(e1: InputEvent, e2: InputEvent) -> bool:
	if e1 == e2:
		return true
	if !e1 and e2 or e1 and !e2:
		return false
	if e1.get_class() != e2.get_class():
		return false
	if e1 is InputEventKey:
		var e1k:InputEventKey = e1
		var e2k:InputEventKey = e2
		if e1k.scancode != e2k.scancode or e1k.physical_scancode != e2k.physical_scancode:
			return false
	elif e1.button_index != e2.button_index:
		return false
	return true


static func are_event_arrays_same(events1: Array, events2: Array) -> bool:
	if events1.size() != events2.size():
		return false
	for i in events1.size():
		if !are_events_same(events1[i], events2[i]):
			return false
	return true


