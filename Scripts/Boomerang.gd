class_name Boomerang
extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var hammer_retrieval_particles = $HammerRetrieval_GPUParticles2D

@export var max_fly_time: float = 2.5
@export var speed = 300

var is_flying = false
var remaining_fly_time = max_fly_time


func _ready() -> void:
	EventBus.connect("fly_time_reset", disable_boomerang)
	EventBus.connect("throw_boomerang", enable_boomerang)
	
	# Pretty ugly, but needed to fix first time instancing stuttering
	hammer_retrieval_particles.show()
	hammer_retrieval_particles.hide()
	
	disable_boomerang()


func _physics_process(delta: float) -> void:
	if is_flying:
		remaining_fly_time -= delta
		
		if remaining_fly_time <= 0:
			is_flying = false
			linear_damp = 3
			hammer_retrieval_particles.show()
			EventBus.emit_signal("fly_time_finished")
		
		else:
			var mouse_position = get_global_mouse_position()
			var direction =  mouse_position - global_position
			
			var motion_vector = direction.normalized() * speed
			apply_central_force(motion_vector)
			rotate(.05)
			
			var remaining_fly_time_percentage = (remaining_fly_time * 100) / max_fly_time
			EventBus.emit_signal("fly_time_update", remaining_fly_time_percentage)


func drop_boomerang():
	remaining_fly_time = 0


func disable_boomerang():
	linear_velocity = Vector2.ZERO
	process_mode = PROCESS_MODE_DISABLED
	hide()


func enable_boomerang(starting_global_position):
	process_mode = PROCESS_MODE_INHERIT
	
	global_position = starting_global_position
	var mouse_position = get_global_mouse_position()
	var direction =  mouse_position - global_position
	look_at(direction)
	
	var motion_vector = direction.normalized() * speed
	apply_central_force(motion_vector)
	rotate(.05)
	
	hammer_retrieval_particles.hide()
	show()
	remaining_fly_time = max_fly_time
	is_flying = true


func _on_body_entered(body: Node) -> void:
	# Collision layer 8 is environment
	if body.collision_layer == 8:
		EventBus.emit_signal("spawn_spark_particles", global_position)
