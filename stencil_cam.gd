extends Camera3D

@export var main_cam_path: NodePath
var main_cam: Camera3D

func _ready() -> void:
	main_cam = get_node_or_null(main_cam_path)
	if main_cam == null:
		print("Main cam not found", main_cam_path)
		
func _process(delta: float) -> void:
	if main_cam != null:
		global_transform = main_cam.global_transform
