extends Spatial

onready var player := $Player
onready var settings_editor := $CanvasLayer/SettingsEditor

var settings_file

func _ready() -> void:
	settings_editor.connect("closebutton_pressed", self, "_close_settings")
	settings_file = preload("res://Player/PlayerShipSettings.tres")
	player.settings = settings_file
	settings_editor.settings = settings_file

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_open_settings"):
		if not settings_editor.visible:
			settings_editor.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			settings_editor.hide()
		get_tree().paused = settings_editor.visible

func _close_settings() -> void:
	settings_editor.hide()
	get_tree().paused = settings_editor.visible
