extends Node2D


@onready var enemies_parent_node = $EnemiesParentNode
@onready var enemies_spawn_timer = $EnemiesSpawnTimer as Timer
@onready var enemy_spawn_buildup_particles = $EnemySpawnBuildup_GPUParticles2D as GPUParticles2D
@onready var enemy_spawn_flare_particles = $EnemySpawnFlare_GPUParticles2D as GPUParticles2D

@export var enemy_scene: PackedScene
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var spawn_cooldown: float = 1.5
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var initial_spawn_wait_time: float = 3
## To spawn enemies indefinitely, set this to -1
@export var max_enemies_number: int = 3

@export_category("Difficulty ramp up")
@export var hard_enemy_scene: PackedScene
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var hard_spawn_cooldown: float = 0.5
## To spawn enemies indefinitely, set this to -1
@export var hard_max_enemies_number: int = -1

var enemies_left_to_spawn: int
var is_difficulty_ramped_up = false


func _ready() -> void:
	enemies_spawn_timer.wait_time = spawn_cooldown
	enemies_left_to_spawn = max_enemies_number
	
	EventBus.connect("difficulty_ramp_up", difficulty_ramp_up)
	EventBus.connect("difficulty_down", difficulty_down)
	
	await get_tree().create_timer(initial_spawn_wait_time).timeout
	enemies_spawn_timer.start()
	
	if enemy_scene != null:
		enemy_spawn_buildup_particles.lifetime = spawn_cooldown
		enemy_spawn_buildup_particles.restart()
	
	# Pretty ugly, but needed to fix first time instancing stuttering
	enemy_spawn_buildup_particles.emitting = true
	enemy_spawn_buildup_particles.emitting = false
	enemy_spawn_flare_particles.emitting = true
	enemy_spawn_flare_particles.emitting = false


func difficulty_ramp_up():
	is_difficulty_ramped_up = true
	enemies_left_to_spawn = hard_max_enemies_number
	enemies_spawn_timer.wait_time = hard_spawn_cooldown
	
	enemy_spawn_buildup_particles.lifetime = hard_spawn_cooldown
	
	enemies_spawn_timer.start()
	enemy_spawn_buildup_particles.restart()


func difficulty_down():
	is_difficulty_ramped_up = false
	enemies_left_to_spawn = max_enemies_number
	enemies_spawn_timer.wait_time = spawn_cooldown
	
	enemy_spawn_buildup_particles.lifetime = spawn_cooldown
	
	enemies_spawn_timer.start()
	enemy_spawn_buildup_particles.restart()


func _on_enemies_spawn_timer_timeout() -> void:
	var enemy_instance
	
	if not is_difficulty_ramped_up:
		if enemy_scene == null:
			return
		enemy_instance = enemy_scene.instantiate()
	else:
		if hard_enemy_scene == null:
			return
		enemy_instance = hard_enemy_scene.instantiate()
	
	enemies_parent_node.add_child(enemy_instance)
	EventBus.emit_signal("play_enemy_spawn_sound")
	
	enemy_spawn_flare_particles.restart()
	
	enemies_left_to_spawn -= 1
	if enemies_left_to_spawn == 0:
		enemies_spawn_timer.stop()
	
	if not enemies_spawn_timer.is_stopped():
		enemy_spawn_buildup_particles.restart()
