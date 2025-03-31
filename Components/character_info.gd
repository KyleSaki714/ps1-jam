extends Node3D

class_name CharacterInfo

enum CHAR_TYPES {
	HUMAN,
	RAT
}

@export var _char_type : CHAR_TYPES


func getCharacterType():
	return _char_type
