extends StaticBody3D

class_name cage

func release():
	$cage.visible = false
	$wall1.disabled = true
	$wall2.disabled = true
	$wall3.disabled = true
	$wall4.disabled = true
	$wall5.disabled = true
	$wall6.disabled = true
	
