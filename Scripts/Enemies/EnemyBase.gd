class_name EnemyBase
extends CharacterBody2D


var main_character: MainCharacter

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D


func _ready() -> void:
	main_character = get_tree().get_first_node_in_group("MainCharacter")
	EventBus.connect("player_death", stop_chasing_player)


func stop_chasing_player():
	pass


func take_damage():
	EventBus.emit_signal("spawn_blood_particles", global_position)
	EventBus.emit_signal("spawn_spark_particles", global_position)
	EventBus.emit_signal("play_thunder_sfx")
	EventBus.emit_signal("play_lightning_sfx", -5)
	EventBus.emit_signal("screen_shake")
	queue_free()
