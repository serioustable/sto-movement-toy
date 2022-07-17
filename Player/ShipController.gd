extends KinematicBody

var settings : ShipSettings setget set_settings

var min_yaw_speed := 5.0
var max_yaw_speed := 26.0
var min_pitch_speed := 5.0
var max_pitch_speed := 26.0
var max_pitch_angle := 60.0
var max_roll_offset := 45.0
var roll_rate := 0.45
var max_forward_speed := 100.0
var accel_rate := 2.0
var inertia_factor := 65

onready var yaw_gimbal := $YawGimbal
onready var pitch_gimbal := $YawGimbal/PitchGimbal
onready var ship_model := $YawGimbal/PitchGimbal/Ship

var _yaw_input
var _pitch_input
var _current_throttle_step := 0
var _velocity := Vector3.ZERO
var _forward_speed := 0.0
var _stored_inertia_vector := Vector3.ZERO

func set_settings(new_settings : ShipSettings) -> void:
	if new_settings == settings:
		return
	
	settings = new_settings
	new_settings.connect("changed", self, "set_ship_values")
	set_ship_values()

func set_ship_values() -> void:
	min_yaw_speed = settings.min_yaw_speed
	max_yaw_speed = settings.max_yaw_speed
	min_pitch_speed = settings.min_pitch_speed
	max_pitch_speed = settings.max_pitch_speed
	max_pitch_angle = settings.max_pitch_angle
	max_roll_offset = settings.max_roll_offset
	roll_rate = settings.roll_rate
	max_forward_speed = settings.max_forward_speed
	accel_rate = settings.accel_rate
	inertia_factor = settings.inertia_factor

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("movement_throttle_up"):
		_current_throttle_step += 1
		_current_throttle_step = clamp(_current_throttle_step, -1, 4)
		if _current_throttle_step == 0:
			_stored_inertia_vector = ship_model.global_transform.basis.z
	if Input.is_action_just_pressed("movement_throttle_down"):
		_current_throttle_step -= 1
		if _current_throttle_step == 0:
			_stored_inertia_vector = ship_model.global_transform.basis.z
		_current_throttle_step = clamp(_current_throttle_step, -1, 4)
	if Input.is_action_just_pressed("movement_toggle_full_stop"):
		if _current_throttle_step == -1 or _current_throttle_step == 4:
			_current_throttle_step = 0
		elif _current_throttle_step <= 2 and _current_throttle_step != 0:
			_current_throttle_step = 0
		else:
			_current_throttle_step = 4
		if _current_throttle_step == 0:
			_stored_inertia_vector = ship_model.global_transform.basis.z

	_yaw_input = Input.get_axis("movement_yaw_right", "movement_yaw_left")
	_pitch_input = Input.get_axis("movement_pitch_down", "movement_pitch_up")
	
	var current_yaw_speed := clamp(max_yaw_speed * (_forward_speed / max_forward_speed) * 4.0, min_yaw_speed, max_yaw_speed)
	var current_pitch_speed := clamp(max_pitch_speed * (_forward_speed / max_forward_speed) * 4.0, min_pitch_speed, max_pitch_speed)
	
	yaw_gimbal.rotate_y(deg2rad(current_yaw_speed) * _yaw_input * delta)
	pitch_gimbal.rotate_x(deg2rad(current_pitch_speed) * _pitch_input * delta)
	pitch_gimbal.rotation_degrees.x = clamp (pitch_gimbal.rotation_degrees.x, -max_pitch_angle, max_pitch_angle)
	
	ship_model.rotation_degrees.z = lerp(
		ship_model.rotation_degrees.z, 
		_yaw_input * -max_roll_offset * ((_forward_speed / max_forward_speed) * 4.0 ), 
		roll_rate * delta)
	ship_model.rotation_degrees.z = clamp(ship_model.rotation_degrees.z, -max_roll_offset, max_roll_offset)

func _physics_process(delta: float) -> void:
	var desired_velocity
	var desired_forward_speed = max_forward_speed * (_current_throttle_step / 4.0)
	_forward_speed = lerp(_forward_speed, desired_forward_speed, accel_rate * delta)
	if abs(_forward_speed - desired_forward_speed) < 1.0:
		_forward_speed = desired_forward_speed
	if _current_throttle_step != 0:
		desired_velocity = ship_model.global_transform.basis.z * _forward_speed
	else: 
		desired_velocity = _stored_inertia_vector * _forward_speed
	var steering_vector = desired_velocity - _velocity
	_velocity += steering_vector * (inertia_factor / 1000.0)
	if _velocity.length() < 0.1:
		_velocity = Vector3.ZERO
	move_and_slide(_velocity, Vector3.UP)
	
