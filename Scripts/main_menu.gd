extends CanvasLayer

@onready var main_menu_panel = $MainMenuPanel
@onready var settings_panel = $SettingsPanel
@onready var credits_panel = $CreditsPanel
@onready var sensitivity_slider = $SettingsPanel/SensitivitySlider
@onready var sensitivity_label = $SettingsPanel/SensitivityLabel
@onready var volume_slider = $SettingsPanel/VolumeSlider
@onready var volume_label = $SettingsPanel/VolumeLabel


var sensitivity: float = 1.0
var volume: float = 0.5

func _ready() -> void:

	main_menu_panel.visible = true
	settings_panel.visible = false
	credits_panel.visible = false
	

	$MainMenuPanel/StartButton.pressed.connect(_on_start_button_pressed)
	$MainMenuPanel/SettingsButton.pressed.connect(_on_settings_button_pressed)
	$MainMenuPanel/CreditsButton.pressed.connect(_on_credits_button_pressed)
	$MainMenuPanel/ExitButton.pressed.connect(_on_exit_button_pressed)
	

	$SettingsPanel/BackButton.pressed.connect(_on_back_button_pressed)
	$CreditsPanel/BackButton.pressed.connect(_on_back_button_pressed)

	if sensitivity_slider:
		sensitivity_slider.value = sensitivity
		sensitivity_slider.value_changed.connect(_on_sensitivity_changed)
	if volume_slider:
		volume_slider.value = volume
		volume_slider.value_changed.connect(_on_volume_changed)
	

	_update_sensitivity_label()
	_update_volume_label()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/started video.tscn")
	print("Start game")

func _on_settings_button_pressed() -> void:
	main_menu_panel.visible = false
	settings_panel.visible = true
	credits_panel.visible = false
	print("Open settings")

func _on_credits_button_pressed() -> void:
	main_menu_panel.visible = false
	settings_panel.visible = false
	credits_panel.visible = true
	print("Open credits")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	print("Exit game")

func _on_back_button_pressed() -> void:
	main_menu_panel.visible = true
	settings_panel.visible = false
	credits_panel.visible = false
	print("Return to main menu")

func _on_sensitivity_changed(value: float) -> void:
	sensitivity = value
	_update_sensitivity_label()
	print("Sensitivity changed to: ", sensitivity)

func _on_volume_changed(value: float) -> void:
	volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
	_update_volume_label()
	print("Volume changed to: ", volume)

func _update_sensitivity_label() -> void:
	if sensitivity_label:
		sensitivity_label.text = "Sensitivity: %.2f" % sensitivity

func _update_volume_label() -> void:
	if volume_label:
		volume_label.text = "Volume: %.0f%%" % (volume * 100)
