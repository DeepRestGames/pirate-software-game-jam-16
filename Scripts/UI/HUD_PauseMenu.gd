extends Control


@onready var pause_menu = $Panel


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_continue_button_pressed()
		else:
			pause_menu.show()
			get_tree().paused = true


func _on_continue_button_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false




func _on_level_selection_button_pressed() -> void:
	pass
	#get_tree().change_scene_to_file("levelSelection")


func _on_main_menu_button_pressed() -> void:
	_on_continue_button_pressed()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
