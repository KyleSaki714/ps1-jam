extends Node3D

class_name PlayerCore

@export var _moveComponent : MoveComponent
#signal input_info

@export var _mouseSens = 0.5

var _mouseCaptured = false

func _ready():
	capture_mouse()

func _process(delta: float) -> void:
	var move_vec : Vector3
	if _moveComponent == null:
		return
	
	if (Input.is_action_pressed("move_forward")):
		_moveComponent.set_move_vec(0)
	if (Input.is_action_pressed("move_backward")):
		_moveComponent.set_move_vec(1)
	if (Input.is_action_pressed("move_left")):
		_moveComponent.set_move_vec(2)
	if (Input.is_action_pressed("move_right")):
		_moveComponent.set_move_vec(3)
	if (Input.is_action_pressed("jump")):
		_moveComponent.set_jump(true)
	else:
		_moveComponent.set_jump(false)
	if Input.is_action_pressed("pause"):
		release_mouse()
	#if (Input.is_action_pressed("interact")):
		# TODO: interacting, transfer control to rat
		#pass
	
	#emit_signal("input_info", move_vec)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if (Input.is_action_just_pressed("debug_transfer_dude")):
		print("transfer to dude")
		var dude = get_tree().root.get_node_or_null("SubViewportContainer/SubViewport/World/Dude")
		if dude != null:
			_moveComponent._camera.current = false
			reparent(dude)
			_moveComponent = dude.get_node_or_null("MoveComponent")
			_moveComponent._camera.current = true
	if (Input.is_action_just_pressed("debug_transfer_rat")):
		print("transfer to rat")
		var rat = get_tree().root.get_node_or_null("SubViewportContainer/SubViewport/World/Rat")
		if rat != null:
			# deactivate old camera
			_moveComponent._camera.current = false
			reparent(rat)
			_moveComponent = rat.get_node_or_null("MoveComponent")
			_moveComponent._camera.current = true
		

func _input(event: InputEvent) -> void:
	if _moveComponent == null:
		push_error("_moveComponent is null for PlayerCore!")
		return
	
	if _mouseCaptured and event is InputEventMouseMotion:
		#print("call mouse motion")
		_moveComponent.set_mouse_motion(event.relative, _mouseSens)
		#print(type_string(typeof(event.relative)))
	
	#if event is InputEventKey and event.pressed:
		#if event.scancode in hotkeys:
			#weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	#if event is InputEventMouseButton and event.pressed:
		#if event.button_index == MOUSE_BUTTON_LEFT
		#if event.button_index == BUTTON_WHEEL_DOWN:
			#weapon_manager.switch_to_next_weapon()
		#if event.button_index == BUTTON_WHEEL_UP:
			#weapon_manager.switch_to_last_weapon()
	

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouseCaptured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_mouseCaptured = false
