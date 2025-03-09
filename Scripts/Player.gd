extends Node3D

func _process(delta: float) -> void:
	var move_vec : Vector3
	if (Input.is_action_pressed("move_forward")):
		move_vec += Vector3.FORWARD
	if (Input.is_action_pressed("move_backward")):
		move_vec += Vector3.BACK
	if (Input.is_action_pressed("move_left")):
		move_vec += Vector3.LEFT
	if (Input.is_action_pressed("move_right")):
		move_vec += Vector3.RIGHT
	
	print(move_vec)
