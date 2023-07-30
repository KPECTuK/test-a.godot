class_name ControllerPawn extends Node3D

const nameInputEventForward: String = "scn_move_forward"
const nameInputEventBack: String = "scn_move_back"
const nameInputEventLeft: String = "scn_move_left"
const nameInputEventRight: String = "scn_move_right"

@export var speedKey1: = Vector3.FORWARD
@export var speedKey2: = Vector3.BACK
@export var speedKey3: = Vector3.LEFT
@export var speedKey4: = Vector3.RIGHT

var accel: float = 3.0
var _mapInput = { }


func _ready():
	var basePlane = Plane.PLANE_XZ
	$Pawn.set_values( \
		basePlane, \
		Vector3(1.0 ,0.0 ,0.0) * 10.0, \
		Vector3(1.0, 0.0, 1.0) * 10.0, \
		Vector3.ZERO, \
		Vector3(0.0 ,0.0 ,1.0) * 10.0 )

	# initial speeds are projected and pre-multipied by acceleration
	# the set is the set of accelerations
	_mapInput[nameInputEventForward] = basePlane.project(speedKey1) * accel
	_mapInput[nameInputEventBack] = basePlane.project(speedKey2) * accel
	_mapInput[nameInputEventLeft] = basePlane.project(speedKey3) * accel
	_mapInput[nameInputEventRight] = basePlane.project(speedKey4) * accel


func _process(delta):
	
	if not Input.is_anything_pressed():
		# can be commented out in purpose of checking bounce algorithm
		var speed = $Pawn.speed
		$Pawn.speed -= speed.normalized() * speed.length() * accel * delta
	
	if Input.is_action_pressed(nameInputEventForward):
		$Pawn.speed += _mapInput[nameInputEventForward] * delta

	if Input.is_action_pressed(nameInputEventBack):
		$Pawn.speed += _mapInput[nameInputEventBack] * delta

	if Input.is_action_pressed(nameInputEventLeft):
		$Pawn.speed += _mapInput[nameInputEventLeft] * delta

	if Input.is_action_pressed(nameInputEventRight):
		$Pawn.speed += _mapInput[nameInputEventRight] * delta
