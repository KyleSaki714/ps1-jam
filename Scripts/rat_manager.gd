extends Node3D

@export var player: PlayerCore
@export var rats: Array[Rat]

func _ready() -> void:
	player.setRatXray.connect(_on_set_rat_xray)
	
func _on_set_rat_xray(xrayOn):
	for rat in rats:
		rat.setXray(xrayOn)
