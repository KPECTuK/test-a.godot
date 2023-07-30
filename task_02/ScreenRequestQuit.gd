class_name ScreenRequestQuit extends Control

var mapCommandDocarator = {
	"cmd_accept": "cmd_request_quit_accept",
	"cmd_reject": "cmd_initial",
}

func on_event_received(source: Control, commandName: String):
	print("event received: '%s' %s" % [ commandName, source ])
	if not commandName in mapCommandDocarator.keys():
		printerr("command decorator is not found")
	else:
		var parent = get_parent()
		while parent != null and not 'on_event_received' in parent:
			parent = parent.get_parent()
		if parent != null:
			parent.on_event_received(source, mapCommandDocarator[commandName])
		else:
			print("event stop at: %s" % self)
