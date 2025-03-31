extends Node3D

@export var dialogue_start: String= "start"
@onready var spotlight = $"../SpotLight3D"
@onready var roomlight = $"../roomlight"

	

func _on_timer_timeout():
	$"../roomlight".visible = true
	$"../SpotLight3D".visible = true
	
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(load("res://Dialogue/main.dialogue"), dialogue_start)
