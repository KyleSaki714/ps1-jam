extends Node3D

class_name MoveComponent

@export var _bodyToMove : CharacterBody3D = null
@export var _camera : Camera3D = null

@export var _moveAccel = 2
@export var _maxSpeed = 10
var _drag = 0.0 # calcs in _ready
@export var _jumpForce = 10
@export var _gravity = 60

var _pressedJump = false 
var _moveVec : Vector3 # auto inits to Vector3.ZERO
var _velocity : Vector3
var _snapVec : Vector3 # how body "sticks" to the ground when moving
var _mouseMotion : Vector2
var _mouseSens # factor in mouse sensitivity 

var frozen = false

func _ready():
	_drag = float(_moveAccel) / _maxSpeed
	_mouseMotion = Vector2.ZERO
	_mouseSens = 0.0
	
func init(_body_to_move : CharacterBody3D):
	_bodyToMove = _body_to_move

# method to set the move vector using the _bodyToMove's 
# transform basis 
# (so that movement is relative to the _bodyToMove) 
# 0: forward, 1: backward, 2: left, 3: right
func set_move_vec(dir : int):
	match dir:
		0:
			_moveVec -= _bodyToMove.transform.basis.z
		1: 
			_moveVec += _bodyToMove.transform.basis.z
		2:
			_moveVec -= _bodyToMove.transform.basis.x
		3:
			_moveVec += _bodyToMove.transform.basis.x
		_:
			_moveVec = Vector3.ZERO
	_moveVec = _moveVec.normalized()

func set_mouse_motion(mm : Vector2, ms : float):
	_mouseMotion = mm
	_mouseSens = ms

func clear_mouse_motion():
	_mouseMotion = Vector2.ZERO
	_mouseSens = 0.0

func set_jump(pressedJump: bool):
	_pressedJump = pressedJump

func _physics_process(delta: float) -> void:
	if _bodyToMove == null or _camera == null:
		push_error("_bodyToMove or _camera is null for MoveComponent!")
		return
	if frozen:
		return

	# --- Mouse Motion ---
	_bodyToMove.rotation_degrees.y -= _mouseSens * _mouseMotion.x
	_camera.rotation_degrees.x -= _mouseSens * _mouseMotion.y
	_camera.rotation_degrees.x = clamp(_camera.rotation_degrees.x, -90, 90)
	clear_mouse_motion()

	# --- Movement ---
	var grounded = _bodyToMove.is_on_floor()
	# if player is already grounded, much smaller gravity will be applied
	if grounded:
		_velocity += (_moveAccel * _moveVec) - (_velocity * Vector3(_drag, 0.0, _drag)) + (0.01 * Vector3.DOWN) * delta
	else:
		_velocity += (_moveAccel * _moveVec) - (_velocity * Vector3(_drag, 0.0, _drag)) + (_gravity * Vector3.DOWN) * delta
		
	_bodyToMove.set_velocity(_velocity)
	_bodyToMove.move_and_slide()
	
	_moveVec = Vector3.ZERO
	
	if grounded and _pressedJump:
		_velocity.y = _jumpForce
	_pressedJump = false

func freeze():
	frozen = true

func unfreeze():
	frozen = false
