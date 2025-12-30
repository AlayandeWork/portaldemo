extends Node

var portal_camera: Camera3D
var main_viewport: Viewport
var current_portal: Camportal

func _ready() -> void:
	main_viewport = get_viewport()
