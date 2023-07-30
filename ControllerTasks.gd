extends Node


var protoSceneUi = preload("res://task_02/_main.tscn")
var protoSceneTask3 = preload("res://task_03/_main.tscn")

var _current: Node = null


func _ready():
	_current = protoSceneUi.instantiate()
	add_child(_current)


func reload_ui():
	if _current != null:
		_current.queue_free()
	_current = protoSceneUi.instantiate()
	add_child(_current)


func reload_scene():
	if _current != null:
		_current.queue_free()
	_current = protoSceneTask3.instantiate()
	add_child(_current)
