class_name ButtonSignal extends Button

@export var command_name: String


func _ready():
	var parent = get_parent()
	while parent != null and not 'get_button_text_for_command' in parent:
		parent = parent.get_parent()
	if parent != null:
		text = parent.get_button_text_for_command(command_name)


func _on_pressed():
	#! but, that might be to use '.propagate_notification()' with custom notification code is a better way
	print("bubble up event starts with command: %s" % command_name)
	var parent = get_parent()
	while parent != null and not 'on_event_received' in parent:
		parent = parent.get_parent()
	if parent != null:
		parent.on_event_received(self, command_name)
	else:
		print("event stop at: %s" % self)
