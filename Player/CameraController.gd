extends Spatial

export(float, 0.0, 10.0) var mouse_sensitivity = 2.0
export(float, 0.0, 10.0) var joystick_sensivity = 2.0
export(float, 0.0, 75.0) var pitch_limit_lower = 60.0
export(float, -75.0, 0.0) var pitch_limit_upper = -60.0
export var spring_arm_length_min := 40.0
export var spring_arm_length_max := 200.0
export var spring_arm_change_speed := 40.0

onready var pitch_gimbal := $CameraPitchGimbal
onready var spring_arm := $CameraPitchGimbal/SpringArm

var _rotation_input := 0.0
var _pitch_input := 0.0
var _mouse_input := false

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_pitch_input = -event.relative.y * mouse_sensitivity

func _process(delta: float) -> void:
	#TEMPORARY
	if Input.is_action_just_pressed("camera_right_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("camera_right_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	_rotation_input += Input.get_action_strength("camera_yaw_left") - Input.get_action_strength("camera_yaw_right")
	_pitch_input += Input.get_action_strength("camera_pitch_up") - Input.get_action_strength("camera_pitch_down")
	
	if not _mouse_input:
		_rotation_input *= joystick_sensivity
		_pitch_input *= joystick_sensivity
	
	rotate_y(_rotation_input * delta)
	pitch_gimbal.rotate_x(_pitch_input * delta)
	pitch_gimbal.rotation_degrees.x = clamp(pitch_gimbal.rotation_degrees.x, pitch_limit_upper, pitch_limit_lower)
	
	_rotation_input = 0.0
	_pitch_input = 0.0
