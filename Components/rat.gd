extends CharacterBody3D

class_name Rat

var _xraymaterial : Material = preload("res://shaders/Xraymaterial.tres")
var _xrayon = true

func setXray(turnOn: bool):
	if turnOn:
		$Graphics/rat/grp1.set_material_overlay(_xraymaterial)
	else:
		$Graphics/rat/grp1.set_material_overlay(null)
	_xrayon = turnOn

func turnXrayOff():
	setXray(false)

func turnXrayOn():
	setXray(true)

func getXrayStatus() -> bool:
	return _xrayon

func toggleXray():
	if _xrayon:
		$Graphics/rat/grp1.set_material_overlay(null)
	else:
		$Graphics/rat/grp1.set_material_overlay(_xraymaterial)
	_xrayon = !_xrayon
