class_name ShipSettings
extends Resource

export var min_yaw_speed : float = 5.0 setget min_yaw_speed_changed
export var max_yaw_speed : float = 26.0 setget max_yaw_speed_changed
export var min_pitch_speed : float = 5.0 setget min_pitch_speed_changed
export var max_pitch_speed : float = 26.0 setget max_pitch_speed_changed
export var max_pitch_angle : float = 60.0 setget max_pitch_angle_changed
export var max_roll_offset : float = 45.0 setget max_roll_offset_changed
export var roll_rate : float = 0.45 setget roll_rate_changed
export var max_forward_speed : float = 100.0 setget max_forward_speed_changed
export var accel_rate : float = 0.8 setget accel_rate_changed
export var inertia_factor : float = 30 setget inertia_factor_changed

func min_yaw_speed_changed(new_value : float) -> void:
	min_yaw_speed = new_value
	emit_changed()
	
func max_yaw_speed_changed(new_value : float) -> void:
	max_yaw_speed = new_value
	emit_changed()

func min_pitch_speed_changed(new_value : float) -> void:
	min_pitch_speed = new_value
	emit_changed()

func max_pitch_speed_changed(new_value : float) -> void:
	max_pitch_speed = new_value
	emit_changed()

func max_pitch_angle_changed(new_value : float) -> void:
	max_pitch_angle = new_value
	emit_changed()
	
func max_roll_offset_changed(new_value : float) -> void:
	max_roll_offset = new_value
	emit_changed()

func roll_rate_changed(new_value : float) -> void:
	roll_rate = new_value
	emit_changed()

func max_forward_speed_changed(new_value : float) -> void:
	max_forward_speed = new_value
	emit_changed()

func accel_rate_changed(new_value : float) -> void:
	accel_rate = new_value
	emit_changed()

func inertia_factor_changed(new_value : float) -> void:
	inertia_factor = new_value
	emit_changed()
