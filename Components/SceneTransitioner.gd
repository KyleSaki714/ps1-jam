extends StaticBody3D

class_name SceneTransitioner

func sceneChange():
	get_tree().change_scene_to_file("res://World.tscn")
