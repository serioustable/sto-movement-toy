extends Spatial

export(float, 0.1, 1) var mouse_sensitivity : float = 0.3
export(float, -89.0, 0.0) var min_pitch : float = -75.0
export(float, 0.0, 89.0) var max_pitch : float = 75.0


var rot_x := 0.0
var rot_y := 0.0

onready var spring_arm := $SpringArm
onready var camera := $SpringArm/Camera

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("camera_right_click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("camera_right_click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		rot_x += event.relative.x * mouse_sensitivity
		rot_y += clamp(event.relative.y * mouse_sensitivity, min_pitch, max_pitch)
		rotate_object_local(Vector3(0,1,0), rot_x)
		spring_arm.rotate_object_local(Vector3(1, 0, 1), rot_y)
