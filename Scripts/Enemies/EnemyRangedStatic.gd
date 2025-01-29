class_name EnemyRangedStatic
extends StaticBody2D


var main_character: MainCharacter

@onready var line_of_sight = $RayCast2D as RayCast2D

@export var projectile_scene = preload("res://Scenes/Enemies/EnemyProjectile.tscn")

@export var shooting_cooldown: float = 2.5
var current_shooting_cooldown = 0


func _ready() -> void:
	main_character = get_tree().get_first_node_in_group("MainCharacter")


func _physics_process(delta: float) -> void:
	current_shooting_cooldown -= delta
	handle_line_of_sight()


func handle_line_of_sight():
	line_of_sight.target_position = to_local(main_character.global_position)
	
	#if line_of_sight.is_colliding():
		#if line_of_sight.get_collider().is_in_group("MainCharacter"):
	if current_shooting_cooldown <= 0:
		shoot()
		current_shooting_cooldown = shooting_cooldown


func shoot():
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.global_position = position
	get_parent().add_child(projectile_instance)
