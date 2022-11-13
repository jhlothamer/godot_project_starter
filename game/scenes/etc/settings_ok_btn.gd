extends TransitionButton

@export var saving_node: NodePath


func _can_transition() -> bool:
	var sn = get_node(saving_node)
	if !sn:
		printerr("Ok button can't perform save - bad save node property")
		return false
	
	return sn.save()
