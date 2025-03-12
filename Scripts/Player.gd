extends Node3D

class_name PlayerCore

@onready var _testVisualizer = preload("res://Components/TestViz.tscn")
@export var _moveComponent : MoveComponent
@export var _transferDistance = 8 # the radius to reach rats to control
@export var _mouseSens = 0.5

var _mouseCaptured = false
var _currentInteractObject = null # the object the player is currently looking at

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
	if (Input.is_action_pressed("interact")):
		if _currentInteractObject is CharacterBody3D:
			transferPlayer(_currentInteractObject)
			# TODO: make a cooldown for transferring control? 
		if _currentInteractObject is SceneTransitioner:
			# for future reference I don't think StaticBody is supposed to be
			# used like this, I think an Area3D is better.
			_currentInteractObject.sceneChange()
	
	# --- RAYCAST FOR INTERACTION SYSTEM ---
	var query = createRaycastQuery()
	
	var world = get_world_3d()
	if world == null:
		return
	var spaceState = world.direct_space_state
	var result = spaceState.intersect_ray(query)
	if !result.is_empty():
		_currentInteractObject = result["collider"]
		print(_currentInteractObject)
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if (Input.is_action_just_pressed("debug_transfer_dude")):
		print("transfer to dude")
		var dude = get_tree().root.get_node_or_null("SubViewportContainer/SubViewport/World/Dude")
		transferPlayer(dude)
	if (Input.is_action_just_pressed("debug_transfer_rat")):
		print("transfer to rat")
		var rat = get_tree().root.get_node_or_null("SubViewportContainer/SubViewport/World/Rat")
		transferPlayer(rat)
		

func _input(event: InputEvent) -> void:
	if _moveComponent == null:
		push_error("_moveComponent is null for PlayerCore!")
		return
	
	# if there is mouse motion detected, send it to the move component
	if _mouseCaptured and event is InputEventMouseMotion:
		_moveComponent.set_mouse_motion(event.relative, _mouseSens)
	

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouseCaptured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_mouseCaptured = false
	
func transferPlayer(newBody : CharacterBody3D):
	if newBody is not CharacterBody3D:
		push_error("new body is not CharacterBody3D!")
		return
	var mc = newBody.get_node_or_null("MoveComponent")
	var cam = newBody.get_node_or_null("Camera3D")
	if mc == null or cam == null:
		push_error("new body does not have a MoveComponent!")
		return
	
	# deactivate the old camera
	_moveComponent._camera.current = false
	reparent(newBody)
	_moveComponent = newBody.get_node_or_null("MoveComponent")
	_moveComponent._camera.current = true

# using a starting point, direction vector, and distance float, use
# the camera and current body's rotation to create a raycast
# that checks for collisions in front of the camera
func createRaycastQuery() -> PhysicsRayQueryParameters3D:
	# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html#raycast-query

	# get the camera's position in global space
	var cameraPos = _moveComponent._camera.global_position
	# using the X rotation from the camera, and the Y rotation from the current CharacterBody3D,
	# create the direction vector (rayDir) that points in the direction of the camera.  
	var xRot = deg_to_rad(_moveComponent._camera.rotation_degrees.x) # Pitch
	var yRot = deg_to_rad(get_parent_node_3d().rotation_degrees.y) # Yaw
	# apply basis vectors transformation
	# thanks to ChatGPT https://chatgpt.com/share/67ce3226-c2e4-8001-b540-97d23755dd49
	var basis = Basis(Vector3.UP, yRot) * Basis(Vector3.RIGHT, xRot) # apply yaw, then pitch
	var rayDir = basis * Vector3.FORWARD
	# get the 2nd point _transferDistance units away from cameraPos
	var secondCameraPos = rayDir * _transferDistance + cameraPos
	
	# DEBUG: view the farthest point player can reach
	#var testVizInst2 = _testVisualizer.instantiate()
	#get_tree().root.get_node_or_null("SubViewportContainer/SubViewport/World/").add_child(testVizInst2)
	#testVizInst2.global_position = secondCameraPos
	
	# create the raycast and intersect the ray
	return PhysicsRayQueryParameters3D.create(cameraPos, secondCameraPos, 0b110, [self.get_parent_node_3d().get_rid()]) # 20 is distance
	
