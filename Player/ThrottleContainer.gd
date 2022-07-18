extends PanelContainer

onready var quarter_impulse := $VBoxContainer/HBoxContainer/QuarterImpulse
onready var half_impulse := $VBoxContainer/HBoxContainer/HalfImpulse
onready var threequarter_impulse := $VBoxContainer/HBoxContainer/ThreeQuarterImpule
onready var full_impulse := $VBoxContainer/HBoxContainer/FullImpulse

var disabled_image := preload("res://UI/square_shadow.png")
var enabled_image := preload("res://UI/squareGreen.png")
var reversed_image := preload("res://UI/squareRed.png")


func _on_Player_throttle_changed(new_throttle) -> void:
	match new_throttle:
		-1:
			quarter_impulse.texture = reversed_image
			half_impulse.texture = disabled_image
			threequarter_impulse.texture = disabled_image
			full_impulse.texture = disabled_image
		0:
			quarter_impulse.texture = disabled_image
			half_impulse.texture = disabled_image
			threequarter_impulse.texture = disabled_image
			full_impulse.texture = disabled_image
		1:
			quarter_impulse.texture = enabled_image
			half_impulse.texture = disabled_image
			threequarter_impulse.texture = disabled_image
			full_impulse.texture = disabled_image
		2:
			quarter_impulse.texture = enabled_image
			half_impulse.texture = enabled_image
			threequarter_impulse.texture = disabled_image
			full_impulse.texture = disabled_image
		3:
			quarter_impulse.texture = enabled_image
			half_impulse.texture = enabled_image
			threequarter_impulse.texture = enabled_image
			full_impulse.texture = disabled_image
		4:
			quarter_impulse.texture = enabled_image
			half_impulse.texture = enabled_image
			threequarter_impulse.texture = enabled_image
			full_impulse.texture = enabled_image
