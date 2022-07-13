extends KinematicBody

export var max_yaw_speed := 26.0
export var max_pitch_speed := 26.0
export var max_pitch_angle := 60.0
export var max_roll_offset := 45.0
export var roll_rate := 0.5
export var max_forward_speed := 100.0
export var accel_rate := 2.0
#export var decel_rate := 0.4
export var inertia_factor := 65

onready var yaw_gimbal := $YawGimbal
onready var pitch_gimbal := $YawGimbal/PitchGimbal
onready var ship_model := $YawGimbal/PitchGimbal/Ship

var _yaw_input
var _pitch_input
var _current_throttle_step := 0
var velocity := Vector3.ZERO
var forward_speed := 0.0
var _stored_inertia_vector := Vector3.ZERO

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("movement_throttle_up"):
		_current_throttle_step += 1
		_current_throttle_step = clamp(_current_throttle_step, -1, 4)
		if _current_throttle_step == 0:
			_stored_inertia_vector = -ship_model.global_transform.basis.x
		print("Current Throttle: " + str(_current_throttle_step))
	if Input.is_action_just_pressed("movement_throttle_down"):
		_current_throttle_step -= 1
		if _current_throttle_step == 0:
			_stored_inertia_vector = -ship_model.global_transform.basis.x
		_current_throttle_step = clamp(_current_throttle_step, -1, 4)
		print("Current Throttle: " + str(_current_throttle_step))
	if Input.is_action_just_pressed("movement_toggle_full_stop"):
		if _current_throttle_step == -1 or _current_throttle_step == 4:
			_current_throttle_step = 0
			print("Current Throttle: " + str(_current_throttle_step))
		else:
			_current_throttle_step = 4
			print("Current Throttle: " + str(_current_throttle_step))
		if _current_throttle_step == 0:
			_stored_inertia_vector = -ship_model.global_transform.basis.x

	_yaw_input = Input.get_axis("movement_yaw_right", "movement_yaw_left")
	_pitch_input = Input.get_axis("movement_pitch_down", "movement_pitch_up")
	
	yaw_gimbal.rotate_y(deg2rad(max_yaw_speed) * _yaw_input * delta)
	pitch_gimbal.rotate_x(deg2rad(max_pitch_speed) * _pitch_input * delta)
	pitch_gimbal.rotation_degrees.x = clamp (pitch_gimbal.rotation_degrees.x, -max_pitch_angle, max_pitch_angle)
	ship_model.rotation_degrees.x = lerp(ship_model.rotation_degrees.x, _yaw_input * max_roll_offset * (_current_throttle_step / 2.0 ), roll_rate * delta)
	ship_model.rotation_degrees.x = clamp(ship_model.rotation_degrees.x, -max_roll_offset, max_roll_offset)

func _physics_process(delta: float) -> void:
	var desired_velocity
	forward_speed = lerp(forward_speed, max_forward_speed * (_current_throttle_step / 4.0), 1/accel_rate * delta)
	if _current_throttle_step != 0:
		desired_velocity = -ship_model.global_transform.basis.x * forward_speed
	else: 
		desired_velocity = _stored_inertia_vector * forward_speed
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * (inertia_factor / 100.0)
	move_and_slide(velocity, Vector3.UP)
