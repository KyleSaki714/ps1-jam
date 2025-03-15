extends Node3D


var is_taken: bool = false

func taken() -> void:
	is_taken = true
	$shas.visible = false
	#+1 to key to whoever is holding


func _on_interactable_interacted(interactor):
	if not is_taken:
		$Interactable.queue_free()
		taken()
