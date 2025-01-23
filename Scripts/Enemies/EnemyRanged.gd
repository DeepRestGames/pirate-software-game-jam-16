class_name EnemyRanged
extends EnemyBase


@onready var path_calculation_timer = $PathCalculationTimer as Timer
@onready var line_of_sight = $RayCast2D as RayCast2D
@onready var projectile_scene = preload("res://Scenes/Enemies/EnemyProjectile.tscn")

@export var MOVEMENT_SPEED: float = 150
@export var shooting_cooldown: float = 2.5
var current_shooting_cooldown = 0


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	line_of_sight.target_position = to_local(main_character.global_position)
	
	if line_of_sight.is_colliding():
		if line_of_sight.get_collider().is_in_group("MainCharacter"):
			velocity = Vector2.ZERO
			if current_shooting_cooldown <= 0:
				shoot()
				current_shooting_cooldown = shooting_cooldown + delta
		else:
			var direction = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = direction * MOVEMENT_SPEED
	
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider().is_in_group("Boomerang"):
				take_damage()
	
	current_shooting_cooldown -= delta


func shoot():
	var projectile_instance = projectile_scene.instantiate()
	add_child(projectile_instance)


func stop_chasing_player():
	path_calculation_timer.stop()


func make_path() -> void:
	navigation_agent.target_position = main_character.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()
	pass
