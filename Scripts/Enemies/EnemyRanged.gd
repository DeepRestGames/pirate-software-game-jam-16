class_name EnemyRanged
extends EnemyBase


@onready var path_calculation_timer = $PathCalculationTimer as Timer
@onready var line_of_sight = $RayCast2D as RayCast2D
@onready var trajectory_check_left = $TrajectoryCheckLeft_RayCast2D as RayCast2D
@onready var trajectory_check_right = $TrajectoryCheckRight_RayCast2D as RayCast2D
const trajectory_checks_offset = 80

@export var projectile_scene = preload("res://Scenes/Enemies/EnemyProjectile.tscn")

@export var MOVEMENT_SPEED: float = 150
@export var ROTATION_SPEED: float = 3

@export var shooting_cooldown: float = 2.5
var current_shooting_cooldown = 0


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	current_shooting_cooldown -= delta
	handle_line_of_sight(delta)
	handle_collisions()


func handle_line_of_sight(delta):
	line_of_sight.target_position = to_local(main_character.global_position)
	trajectory_check_left.position = line_of_sight.target_position.orthogonal().normalized() * (-trajectory_checks_offset)
	trajectory_check_right.position = line_of_sight.target_position.orthogonal().normalized() * (trajectory_checks_offset)
	
	if line_of_sight.is_colliding():
		if line_of_sight.get_collider().is_in_group("MainCharacter"):
			
			var rotation_direction = (main_character.global_position - global_position).normalized()
			rotation = lerp_angle(rotation, rotation_direction.angle(), ROTATION_SPEED * delta)
			
			if can_shoot(main_character):
				velocity = Vector2.ZERO
				if current_shooting_cooldown <= 0:
					shoot()
					current_shooting_cooldown = shooting_cooldown
				return
				
		move_to_next_path_position(delta)


func can_shoot(target) -> bool:
	# Check trajectory on both sides
	trajectory_check_left.target_position = to_local(target.global_position)
	trajectory_check_right.target_position = to_local(target.global_position)

	if trajectory_check_left.is_colliding() and not trajectory_check_left.get_collider().is_in_group("MainCharacter"):
		return false
	if trajectory_check_right.is_colliding() and not trajectory_check_right.get_collider().is_in_group("MainCharacter"):
		return false
	return true


func move_to_next_path_position(delta):
	var next_point = navigation_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	
	rotation = lerp_angle(rotation, direction.angle(), ROTATION_SPEED * delta)
	
	velocity = direction * MOVEMENT_SPEED


func handle_collisions():
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().is_in_group("Boomerang"):
				take_damage()


func shoot():
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.global_position = position
	get_parent().add_child(projectile_instance)


func stop_chasing_player():
	path_calculation_timer.stop()


func make_path() -> void:
	navigation_agent.target_position = main_character.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()
