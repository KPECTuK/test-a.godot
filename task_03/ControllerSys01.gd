extends Node3D

@export var speedAngle: float = PI * .5
@export var intervalDelaySec: float = 1.0
@export var intervalFadeSec: float = 5.0

var _speed: float = 0.0
var _intervalDelayCurrent = 0.0
var _target: MeshInstance3D = null


class Trail:
	var _instance: MeshInstance3D = null
	var _interval: float = 0.0
	var _alpha: float = 0.0


	func _init(group: Node, proto: MeshInstance3D):
		_instance = proto.duplicate() as MeshInstance3D
		var material = _instance.get_active_material(0)
		_instance.set_surface_override_material(0, material.duplicate())
		group.add_child(_instance)


	func set_instance(proto: MeshInstance3D, interval: float):
		_interval = interval
		_instance.position = proto.position
		_alpha = 1.0


	func process(delta) -> bool:
		_interval -= delta
		if(_interval > 0.0):
			_alpha -= delta / _interval
			var material = _instance.get_surface_override_material(0)
			var color = material.albedo_color
			material.albedo_color = Color(color.r, color.g, color.b, _alpha)
			_instance.set_surface_override_material(0, material)
			return true
		return false


var _active: Array[Trail] = []
var _pool: Array[Trail] = []


func _ready():
	# _speed = fmod(speedAngle - PI, PI)
	_speed = speedAngle
	_intervalDelayCurrent = intervalDelaySec
	_target = $InstLeading


func _process(delta):
	_target.position = _target.position * Quaternion(Vector3.UP, _speed * delta)
	# starting from transparent trail item
	trail_try_set_new(delta)
	trail_update_existing(delta)


func trail_try_set_new(delta):
	_intervalDelayCurrent -= delta
	if _intervalDelayCurrent > 0.0:
		return
	_intervalDelayCurrent = intervalDelaySec
	var desc: Trail = _pool.pop_back() \
		if _pool.size() > 0 \
		else Trail.new(self, _target)
	_active.push_back(desc)
	desc.set_instance(_target, intervalFadeSec)


func trail_update_existing(delta):
	var index = 0
	while index < _active.size():
		if not _active[index].process(delta):
			var trail = _active[index]
			_active.remove_at(index)
			_pool.push_back(trail)
		else:
			index += 1
