extends Node3D

var _bodyToMove : CharacterBody3D = null

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
	
	_velocity = _bodyToMove.move_and_collide()
	
	
	
	
