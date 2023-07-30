class_name ButtonSignal extends Button

@export var command_name: String

func _on_pressed():
	print("bubble up event starts with command: %s" % command_name)
	var parent = get_parent()
	while parent != null and not 'on_event_received' in parent:
		parent = parent.get_parent()
	if parent != null:
		parent.on_event_received(self, command_name)
	else:
		print("event stop at: %s" % self)
