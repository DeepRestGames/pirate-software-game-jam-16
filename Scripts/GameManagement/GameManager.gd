extends Node


var current_level_number: int = 1
var max_level_reached: int = 1

var next_level: PackedScene


func _ready() -> void:
	EventBus.connect("level_started", on_level_started)
	EventBus.connect("next_level", go_to_next_level)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func on_level_started(game_level: GameLevel):
	next_level = game_level.next_level_scene
	current_level_number = game_level.level_number
	
	if current_level_number > max_level_reached:
		max_level_reached = current_level_number


func go_to_next_level():
	get_tree().change_scene_to_packed(next_level)
