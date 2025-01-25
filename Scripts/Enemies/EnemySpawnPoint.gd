extends Node2D


@onready var enemies_parent_node = $EnemiesParentNode
@onready var enemies_spawn_timer = $EnemiesSpawnTimer as Timer

@export var enemy_scene: PackedScene
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var spawn_cooldown: float = 1.5
## To spawn enemies indefinitely, set this to -1
@export var max_enemies_number: int = 3

@export_category("Difficulty ramp up")
@export var hard_enemy_scene: PackedScene
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var hard_spawn_cooldown: float = 0.5
## To spawn enemies indefinitely, set this to -1
@export var hard_max_enemies_number: int = -1

var enemies_left_to_spawn: int = max_enemies_number
var is_difficulty_ramped_up = false


func _ready() -> void:
	enemies_spawn_timer.wait_time = spawn_cooldown
	if hard_enemy_scene == null:
		hard_enemy_scene = enemy_scene
	
	EventBus.connect("difficulty_ramp_up", difficulty_ramp_up)


func difficulty_ramp_up():
	enemies_left_to_spawn = hard_max_enemies_number
	enemies_spawn_timer.wait_time = hard_spawn_cooldown
	enemies_spawn_timer.start()


func _on_enemies_spawn_timer_timeout() -> void:
	var enemy_instance
	
	if not is_difficulty_ramped_up:
		enemies_left_to_spawn -= 1
		if enemies_left_to_spawn == 0:
			enemies_spawn_timer.stop()
		
		enemy_instance = enemy_scene.instantiate()
		
	else:
		enemies_left_to_spawn -= 1
		if enemies_left_to_spawn == 0:
			enemies_spawn_timer.stop()
			
		enemy_instance = hard_enemy_scene.instantiate()
	
	enemies_parent_node.add_child(enemy_instance)
