extends CharacterBody2D


const MOVEMENT_SPEED: float = 300
var main_character: MainCharacter

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D


func _ready() -> void:
	main_character = get_tree().get_first_node_in_group("MainCharacter")


func _physics_process(delta: float) -> void:
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * MOVEMENT_SPEED
	
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider().is_in_group("Boomerang"):
				take_damage()


func take_damage():
	queue_free()


func make_path() -> void:
	navigation_agent.target_position = main_character.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()
