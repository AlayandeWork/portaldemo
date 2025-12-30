extends MeshInstance3D

class_name Camportal

@export var current = false
@export var other_portal_path: NodePath

var other_portal : Camportal = null
var helper : Node3D

func _ready() -> void:
	helper = $Helper
	if not other_portal_path.is_empty():
		other_portal = get_node(other_portal_path)
	if current:
		Global.current_portal = self
		$Inside.visible = true
		
func _process(delta):
	if current:
		var main_cam = get_viewport().get_camera_3d()
		helper.global_transform = main_cam.global_transform
		other_portal.helper.transform = helper.transform
		Global.portal_camera.global_transform = other_portal.helper.global_transform
		var diff  = global_transform.origin - main_cam.global_transform.origin
		var angle = main_cam.global_transform.basis.z.angle_to(diff)
		var near_plane = helper.transform.origin.length() * abs(cos(angle))
		Global.portal_camera.near = max(0.1, near_plane - 4.2)
		if not visible:
			visible = true
	else:
		if visible:
			visible = false

func _on_transfer_area_body_entered(body: Node3D) -> void:
	if not body is Player:
		return
	if not current:
		current = true
		visible = true
	if current and $Inside.visible:
		helper.global_transform = body.global_transform
		other_portal.helper.transform = helper.transform
		body.global_transform = other_portal.helper.global_transform
		current = false
		$Inside.visible = false


func _on_inside_area_body_exited(body: Node3D) -> void:
	if not body is Player:
		return
	if current and not $Inside.visible:
		$Inside.visible = true
