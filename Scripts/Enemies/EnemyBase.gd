class_name EnemyBase
extends CharacterBody2D


@export var MOVEMENT_SPEED: float = 300
var main_character: MainCharacter

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D


func _ready() -> void:
	main_character = get_tree().get_first_node_in_group("MainCharacter")
	EventBus.connect("player_death", stop_chasing_player)


func stop_chasing_player():
	pass


func take_damage():
	queue_free()
