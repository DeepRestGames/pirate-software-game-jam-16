extends Control


@onready var animation_player = $AnimationPlayer
@onready var credits_panel = $HUD/CreditsPanel
@onready var music_volume_slider = $HUD/MenuItems/MUSICSliderContainer/MusicVolumeSlider
@onready var continue_button = $HUD/MenuItems/ContinueButtonContainer/CONTINUE


func _ready():
	animation_player.play("loading_screen", -1, -1, true)
	#Music.start_music()
	#Music.switch_loops(3)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#music_volume_slider.value = Music.get_music_volume()


func _on_credits_button_pressed():
	credits_panel.show()


func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(str(meta))


func _on_credits_panel_mask_pressed():
	credits_panel.hide()


#func _on_music_volume_slider_value_changed(value):
	#Music.set_music_volume(value)


func _on_new_game_button_pressed():
	animation_player.play("loading_screen")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/UI/CinematicIntro.tscn")
