class_name Pawn extends Node3D

# all the class can be divided to controller and math parts
# but, i guess, it's difficult to debug that using engine

var speed: Vector3 = Vector3.FORWARD * 3.0

var _vecTL: Vector3 = Vector3(1.0 ,0.0 ,0.0) * 10.0
var _vecTR: Vector3 = Vector3(1.0, 0.0, 1.0) * 10.0
var _vecBL: Vector3 = Vector3.ZERO
var _vecBR: Vector3 = Vector3(0.0 ,0.0 ,1.0) * 10.0
var _test = [ _vecTL, _vecTR, _vecBR, _vecBL ]

var plane: Plane = Plane.PLANE_XZ

var bounceReflected: Vector3 = Vector3.ZERO
var bounceReminder: Vector3 = Vector3.ZERO
var bounceOrigin: Vector3 = Vector3.ZERO
var bounceResult: Vector3 = Vector3.ZERO
var bounceIndexExlude: int = -1


func set_values(over: Plane, vecTL: Vector3, vecTR: Vector3, vecBL: Vector3, vecBR: Vector3):
	""" input: the base plane and bound points """
	
	_vecTL = over.project(vecTL)
	_vecTR = over.project(vecTR)
	_vecBL = over.project(vecBL)
	_vecBR = over.project(vecBR)
	plane = over
	_test = [ _vecTL, _vecTR, _vecBR, _vecBL ]
	# TODO: crossing check


func get_bounce(origin: Vector3, step: Vector3) -> bool:
	bounceReflected = step
	bounceReminder = Vector3.ZERO
	bounceOrigin = Vector3.ZERO
	bounceResult = origin + step
	var indexEclude = bounceIndexExlude
	bounceIndexExlude =  -1

	var size = len(_test)
	var minDistance = step.length()
	for index in range(size):

		# to exclude oscilation with previous bounce
		if(index == indexEclude):
			continue

		var indexNext = (index + 1) % size
		var current = _test[indexNext] - _test[index]
		var normal = current.cross(plane.normal)
		var planeSide = Plane(normal, _test[index])
		var intersect = planeSide.intersects_segment(origin, origin + step)

		if intersect == null:
			continue

		var toBounce = origin.distance_to(intersect)
		if toBounce < minDistance:
			minDistance = toBounce
			bounceIndexExlude = index
			bounceOrigin = intersect
			bounceReminder = origin + step - bounceOrigin
			bounceReflected = bounceReminder.bounce(planeSide.normal.normalized())
			bounceResult = bounceOrigin + bounceReflected

	if bounceIndexExlude != -1:
		print("middle: %s (%s/%s) %s" % [ bounceOrigin, minDistance, bounceIndexExlude, step.length() ])

	return bounceIndexExlude != -1


func move(delta):
	""" implementation of the method, requested by task """
	
	var step = speed * delta
	var origin = position

	bounceIndexExlude = -1
	while get_bounce(origin, step):
		origin = bounceOrigin
		step = bounceReflected

	position = bounceResult
	var direction = bounceReflected.normalized()
	quaternion *= Quaternion(transform.basis.z, direction)
	speed = direction * speed.length()


func _ready():
	speed = transform.basis.z.normalized() * speed.length()
	quaternion *= Quaternion(transform.basis.z, speed.normalized())


func _process(delta):
	move(delta)
