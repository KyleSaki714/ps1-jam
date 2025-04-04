extends CharacterBody3D

class_name Rat

enum RAT_STATES {
	NORMAL,
	STACKED
}

const COLLISIONLAYER_DEFAULT = 0b11
const COLLISIONLAYER_STACKED = 0b00 # not on the ControllableBodies layer

var _currentState = RAT_STATES.NORMAL

var _xraymaterial : Material = preload("res://shaders/Xraymaterial.tres")
var _xrayon = true

var _currentStackChild : Rat = null # next rat stacked "above" this rat

var _currentStackParent : Rat = null
var _currentStackParentHeight = 0.0

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


# stacks the given rat on this rat.
# if there is already a rat stacked on this one, calls the stackRat method
# on the already stacked one, passing ratToStack up to the next one
func stackRat(ratToStack: Rat):
	if _currentStackChild != null:
		_currentStackChild.stackRat(ratToStack)
		return
	
	_currentStackChild = ratToStack
	ratToStack.stackOn(self)
	

# stack this rat on the given playerRat.
# disables this rat's ControllableBodies collision layer
# freezes MoveComponent
func stackOn(playerRat: Rat):
	print("stackOn")
	_currentStackParent = playerRat
	_currentStackParentHeight = _currentStackParent.get_node("CollisionShape3D").shape.height
	_currentState = RAT_STATES.STACKED
	self.set_collision_layer(COLLISIONLAYER_STACKED)
	self.disable_mode = CollisionObject3D.DISABLE_MODE_REMOVE
	$MoveComponent.freeze()

func _process(delta: float) -> void:
	match _currentState:
		RAT_STATES.NORMAL:
			return
		RAT_STATES.STACKED:
			transform.origin = _currentStackParent.transform.origin
			transform.origin += Vector3(0, _currentStackParentHeight / 2, 0) # half the height of parent rat
			rotation = _currentStackParent.rotation
			return
		_:
			push_error("INVALID RAT STATE")
