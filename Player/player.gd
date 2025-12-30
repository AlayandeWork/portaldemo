extends CharacterBody3D
class_name Player

@export var speed: float = 6.0
@export var jump_force: float = 4.5
@export var mouse_sensitivity: float = 0.2

@onready var cam = $Head

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch: float = 0.0

func _ready():
	Global.portal_camera = $PortalViewPort/PortalCam
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	# Escape unlocks mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -89, 89)
		cam.rotation_degrees.x = pitch

func _physics_process(delta):
	var direction = Vector3.ZERO

	var forward = -transform.basis.z
	var right   =  transform.basis.x

	if Input.is_action_pressed("front"):
		direction += forward
	if Input.is_action_pressed("back"):
		direction -= forward
	if Input.is_action_pressed("left"):
		direction -= right
	if Input.is_action_pressed("right"):
		direction += right

	direction = direction.normalized() * speed

	# gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

	velocity.x = direction.x
	velocity.z = direction.z

	move_and_slide()
