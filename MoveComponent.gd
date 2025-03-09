extends Node3D

class_name MoveComponent

@export var _bodyToMove : CharacterBody3D = null

@export var _moveAccel = 4
@export var _maxSpeed = 25
var _drag = 0.0 # calcs in _ready
@export var _jumpForce = 30
@export var _gravity = 60

var _pressedJump = false 
var _moveVec : Vector3 # auto inits to Vector3.ZERO
var _velocity : Vector3
var _snapVec : Vector3 # how body "sticks" to the ground when moving

var frozen = false

func _ready():
	_drag = float(_moveAccel) / _maxSpeed
	
func init(_body_to_move : CharacterBody3D):
	_bodyToMove = _body_to_move

func set_move_vec(move_vec: Vector3):
	_moveVec = move_vec.normalized()

func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	var cur_move_vec = _moveVec
	
	_velocity += (_moveAccel * cur_move_vec) - (_velocity * Vector3(_drag, 0.0, _drag)) + (_gravity * Vector3.DOWN) * delta
	_bodyToMove.set_velocity(_velocity)
	_bodyToMove.move_and_slide()
	
	var grounded = _bodyToMove.is_on_floor()
	if grounded:
		_velocity.y -= 0.01
	if grounded and _pressedJump:
		_velocity.y = _jumpForce
	_pressedJump = false

func freeze():
	frozen = true

func unfreeze():
	frozen = false

#func on_input_recieved(move_vec: Vector3):
	#set_move_vec(move_vec)
	#print(_moveVec)
#
#func set_player(plr: CorePlayer):
	#_corePlayer = plr
	#connect("input_info", on_input_recieved)
