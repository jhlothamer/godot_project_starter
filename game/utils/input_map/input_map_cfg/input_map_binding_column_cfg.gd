class_name InputMapBindingColumnCfg
extends Resource

enum BindingColumnTypes {
	KeyBoard = 1,
	Mouse = 2,
	GamePad = 4,
}

## name for column
@export var name := ""
## allowed input types for column
@export_flags("Keyboard:1", "Mouse:2", "GamePad:4") var binding_types:int = BindingColumnTypes.KeyBoard


func _type_name_to_column_type(type_name:String) -> BindingColumnTypes:
	if type_name == "InputEventKey": return BindingColumnTypes.KeyBoard
	if type_name == "InputEventMouseButton": return BindingColumnTypes.Mouse
	if type_name == "InputEventJoypadButton": return BindingColumnTypes.GamePad
	assert(false, "Unrecognized input event type name %s" % type_name)
	# add return line to keep interpreter happy
	return BindingColumnTypes.KeyBoard


func is_valid_input_type(input_event_type_name:String) -> bool:
	return binding_types & _type_name_to_column_type(input_event_type_name) > 0


func get_valid_input_type_names() -> Array[String]:
	var type_names:Array[String] = []
	if binding_types & BindingColumnTypes.KeyBoard: type_names.append("InputEventKey")
	if binding_types & BindingColumnTypes.Mouse: type_names.append("InputEventMouseButton")
	if binding_types & BindingColumnTypes.GamePad: type_names.append("InputEventJoypadButton")
	
	return type_names

