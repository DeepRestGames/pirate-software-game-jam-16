class_name EnemyWalking
extends EnemyBase


@onready var path_calculation_timer = $PathCalculationTimer as Timer

@export var MOVEMENT_SPEED: float = 300


func _ready() -> void:
	super._ready()
	make_path()


func _physics_process(delta: float) -> void:
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * MOVEMENT_SPEED
	
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider().is_in_group("Boomerang"):
				take_damage()


func stop_chasing_player():
	path_calculation_timer.stop()


func make_path() -> void:
	navigation_agent.target_position = main_character.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()
