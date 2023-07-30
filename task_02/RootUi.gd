class_name RootUi extends Control

var protoScreenMain = preload("res://task_02/ScreenMain.tscn")
var protoScreenRequestQuit = preload("res://task_02/ScreenRequestQuit.tscn")
var protoScreenRequestScene = preload("res://task_02/ScreenRequestScene.tscn")
var protoVfx = preload("res://task_02/VfxButton.tscn")
var protoScreenScene = preload("res://task_03/_main.tscn")

var screenCurrent: Control = null
var mapCommands = {
	"cmd_initial": command_request_initial,
	"cmd_request_quit": command_request_quit,
	"cmd_request_quit_accept": command_request_quit_accept,
	"cmd_request_scene": command_request_scene,
	"cmd_request_scene_accept": command_request_scene_accept,
	"cmd_request_button_swap": command_request_button_swap,
	"cmd_request_vfx": command_request_vfx,
}


func _ready():
	command_request_initial(self)


func screen_reload(proto: Resource):
	if proto == null:
		return
	var newScreen = proto.instantiate()
	if screenCurrent != null:
		screenCurrent.queue_free()
	screenCurrent = newScreen
	add_child(screenCurrent)


func on_event_received(source: Control, commandName: String):
	print("event received: '%s' %s" % [ commandName, source ])
	if commandName in mapCommands.keys():
		mapCommands[commandName].call(source)
	else:
		printerr("command is not found")


func command_request_initial(_source: Control):
	print("set screen: initial")
	screen_reload(protoScreenMain)


func command_request_quit(_source: Control):
	print("set screen: request quit")
	screen_reload(protoScreenRequestQuit)


func command_request_quit_accept(_source: Control):
	print("request quit")
	# sadly, but i know no ways to rise an exception if any
	# notification type may wary also, especially from different platforms
	# Android have different notification code:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func command_request_scene(_source: Control):
	print("set screen: request scene")
	screen_reload(protoScreenRequestScene)


func command_request_scene_accept(_source: Control):
	print("request scene")
	var parent = get_parent()
	while parent != null && not 'reload_scene' in parent:
		parent = parent.get_parent()
	if parent != null:
		parent.call('reload_scene')


func command_request_button_swap(_source: Control):
	print("swapping buttons")
	# i do not know what is the purpose, that's why containers are just hardcoded
	# there might be options here.. can use `source` for example
	var buttonContainerRight = $ScreenMain/GridContainer/ContainerButton02
	var buttonContainerLeft = $ScreenMain/GridContainer/ContainerButton03
	var buttonRight = buttonContainerRight.get_child(0)
	var buttonLeft = buttonContainerLeft.get_child(0)
	buttonContainerRight.remove_child(buttonRight)
	buttonContainerLeft.remove_child(buttonLeft)
	buttonContainerRight.add_child(buttonLeft)
	buttonContainerLeft.add_child(buttonRight)


func command_request_vfx(source: Control):
	print("request vfx")
	var instance = protoVfx.instantiate() as Node2D
	source.add_child(instance)
	var rect = source.get_rect()
	instance.position = rect.position + Vector2(rect.size.x * randf(), rect.size.y * randf())
	var pSys = instance.get_child(0) as CPUParticles2D
	pSys.emitting = true
	var finalizer = func finalize():
		if instance != null:
			instance.queue_free()
	get_tree() \
		.create_tween() \
		.tween_callback(finalizer) \
		.set_delay(pSys.lifetime)

# end, ide issue
