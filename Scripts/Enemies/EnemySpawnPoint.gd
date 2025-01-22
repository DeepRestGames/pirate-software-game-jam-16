extends Node2D


@onready var enemies_parent_node = $EnemiesParentNode
@onready var enemies_spawn_timer = $EnemiesSpawnTimer as Timer

@export var enemy_scene: PackedScene
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var spawn_cooldown: float = 1.5
## To spawn enemies indefinitely, set this to -1
@export var max_enemies_number: int = 3

var total_spawned_enemies: int = 0


func _ready() -> void:
	enemies_spawn_timer.wait_time = spawn_cooldown


func _on_enemies_spawn_timer_timeout() -> void:
	var enemy_instance = enemy_scene.instantiate()
	enemies_parent_node.add_child(enemy_instance)
	
	total_spawned_enemies += 1
	if total_spawned_enemies >= max_enemies_number:
		enemies_spawn_timer.stop()
