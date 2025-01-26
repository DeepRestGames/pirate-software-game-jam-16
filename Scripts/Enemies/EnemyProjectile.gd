extends StaticBody2D


var main_character: MainCharacter
@export var PROJECTILE_SPEED: float = 200
var direction: Vector2


func _ready() -> void:
	main_character = get_tree().get_first_node_in_group("MainCharacter")	
	direction = to_local(main_character.global_position).normalized()


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * PROJECTILE_SPEED * delta)
	
	if collision != null and not collision.get_collider().is_in_group("MainCharacter"):
		EventBus.emit_signal("spawn_projectile_deflection_particles", global_position)
		queue_free()
