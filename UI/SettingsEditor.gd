extends Control

signal closebutton_pressed

onready var min_yaw_speed_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MinYawSpeed/HSplitContainer/LineEdit
onready var max_yaw_speed_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MaxYawSpeed/HSplitContainer/LineEdit
onready var min_pitch_speed_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MinPitchSpeed/HSplitContainer/LineEdit
onready var max_pitch_speed_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MaxPitchSpeed/HSplitContainer/LineEdit
onready var max_pitch_angle_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MaxPitchAngle/HSplitContainer/LineEdit
onready var max_roll_offset_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MaxRollOffset/HSplitContainer/LineEdit
onready var roll_rate_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/RollRate/HSplitContainer/LineEdit
onready var max_forward_speed_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/MaxForwardSpeed/HSplitContainer/LineEdit
onready var accel_rate_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/AccelRate/HSplitContainer/LineEdit
onready var inertia_factor_line := $PanelContainer/Panel/MarginContainer/OptionsContainer/InertiaFactor/HSplitContainer/LineEdit

onready var default_settings := preload("res://DefaultShipSettings.tres")
var settings : ShipSettings setget load_settings_from_file

func load_settings_from_file(new_settings : ShipSettings) -> void:
	if new_settings == settings:
		return
	
	settings = new_settings
	new_settings.connect("changed", self, "load_current_settings")
	load_current_settings()

func load_current_settings() -> void:
	min_yaw_speed_line.text = str(settings.min_yaw_speed)
	max_yaw_speed_line.text = str(settings.max_yaw_speed)
	min_pitch_speed_line.text = str(settings.min_pitch_speed)
	max_pitch_speed_line.text = str(settings.max_pitch_speed)
	max_pitch_angle_line.text = str(settings.max_pitch_angle)
	max_roll_offset_line.text = str(settings.max_roll_offset)
	roll_rate_line.text = str(settings.roll_rate)
	max_forward_speed_line.text = str(settings.max_forward_speed)
	accel_rate_line.text = str(settings.accel_rate)
	inertia_factor_line.text = str(settings.inertia_factor)

func save_settings() -> void:
	# We create temporary variables so they aren't overwritten by the Resource's setget when it
	# tries to save the first variable to the settings field.
	# We also add clamps to ensure funny, game-breaking numbers aren't entered
	
	var _min_yaw_speed : float = clamp(float(min_yaw_speed_line.text), 0.0, 99.9)
	var _max_yaw_speed : float = clamp(float(max_yaw_speed_line.text), 0.0, 99.9)
	var _min_pitch_speed : float = clamp(float(min_pitch_speed_line.text), 0.0, 99.9)
	var _max_pitch_speed : float = clamp(float(max_pitch_speed_line.text), 0.0, 99.9)
	var _max_pitch_angle : float = clamp(float(max_pitch_angle_line.text), 0.0, 85.0)
	var _max_roll_offset : float = clamp(float(max_roll_offset_line.text), 0.0, 90.0)
	var _roll_rate : float = clamp(float(roll_rate_line.text), 0.0, 99.9)
	var _max_forward_speed : float = clamp(float(max_forward_speed_line.text), 0.0, 400.0)
	var _accel_rate : float = clamp(float(accel_rate_line.text), 0.01, 100.0)
	var _inertia_factor : float = clamp(float(inertia_factor_line.text), 0.0, 400.0)
	
	settings.min_yaw_speed = _min_yaw_speed
	settings.max_yaw_speed = _max_yaw_speed
	settings.min_pitch_speed = _min_pitch_speed
	settings.max_pitch_speed = _max_pitch_speed
	settings.max_pitch_angle = _max_pitch_angle
	settings.max_roll_offset = _max_roll_offset
	settings.roll_rate = _roll_rate
	settings.max_forward_speed = _max_forward_speed
	settings.accel_rate = _accel_rate
	settings.inertia_factor = _inertia_factor

func load_default_settings() -> void:
	min_yaw_speed_line.text = str(default_settings.min_yaw_speed)
	max_yaw_speed_line.text = str(default_settings.max_yaw_speed)
	min_pitch_speed_line.text = str(default_settings.min_pitch_speed)
	max_pitch_speed_line.text = str(default_settings.max_pitch_speed)
	max_pitch_angle_line.text = str(default_settings.max_pitch_angle)
	max_roll_offset_line.text = str(default_settings.max_roll_offset)
	roll_rate_line.text = str(default_settings.roll_rate)
	max_forward_speed_line.text = str(default_settings.max_forward_speed)
	accel_rate_line.text = str(default_settings.accel_rate)
	inertia_factor_line.text = str(default_settings.inertia_factor)


func _on_CloseButton_pressed() -> void:
	emit_signal("closebutton_pressed")


func _on_SaveButton_pressed() -> void:
	save_settings()


func _on_DefaultButton_pressed() -> void:
	load_default_settings()
