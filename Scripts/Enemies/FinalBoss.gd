class_name FinalBoss
extends EnemyBase


@onready var path_calculation_timer = $PathCalculationTimer as Timer

@export var MOVEMENT_SPEED: float = 300
@export var ROTATION_SPEED: float = 3
@export var total_hp: int = 20
var current_hp: int

var colliding_with_hammer = false
var collided_with_hammer_last_frame: bool = false


func _ready() -> void:
	super._ready()
	current_hp = total_hp
	make_path()


func _physics_process(delta: float) -> void:
	var next_point = navigation_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	
	rotation = lerp_angle(rotation, direction.angle(), ROTATION_SPEED * delta)
	
	velocity = direction * MOVEMENT_SPEED

	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider().is_in_group("Boomerang"):
				colliding_with_hammer = true
				
				if collided_with_hammer_last_frame:
					print("Still colliding with hammer")
					return
				
				take_damage()
				collided_with_hammer_last_frame = true
				print("Taken damage from collision")
				return
		
		colliding_with_hammer = false
		collided_with_hammer_last_frame = false
		print("Not colliding with hammer anymore")


func take_damage():
	EventBus.emit_signal("spawn_blood_particles", global_position)
	EventBus.emit_signal("spawn_spark_particles", global_position)
	EventBus.emit_signal("screen_shake")
	
	current_hp -= 1
	
	print("Boss HP: " + str(current_hp))
	
	if current_hp <= 0:
		EventBus.emit_signal("final_boss_defeated")
		queue_free()


func stop_chasing_player():
	path_calculation_timer.stop()


func make_path() -> void:
	navigation_agent.target_position = main_character.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()
