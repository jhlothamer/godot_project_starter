extends Node

var props = {}

func set(name, value):
	props[name] = value
	
func get(name):
	if !props.has(name):
		return null
	return props[name]
	
func erase(name):
	props.erase(name)
	
