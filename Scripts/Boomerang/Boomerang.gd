class_name Boomerang
extends RigidBody2D

@onready var sprite = $Sprite2D

@export_range(2.5, 10) var max_fly_time: float = 2.5
@export var speed = 300

var is_flying = true
var remaining_fly_time = max_fly_time


func _ready() -> void:
	EventBus.connect("fly_time_reset", disable_boomerang)
	EventBus.connect("throw_boomerang", enable_boomerang)


func _physics_process(delta: float) -> void:
	if is_flying:
		remaining_fly_time -= delta
		
		if remaining_fly_time <= 0:
			is_flying = false
			linear_damp = 3
			EventBus.emit_signal("fly_time_finished")
		
		else:
			var mouse_position = get_global_mouse_position()
			var direction =  mouse_position - global_position
			
			var motion_vector = direction.normalized() * speed
			apply_central_force(motion_vector)
			rotate(.05)
			
			var remaining_fly_time_percentage = (remaining_fly_time * 100) / max_fly_time
			EventBus.emit_signal("fly_time_update", remaining_fly_time_percentage)


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
	
	show()
	remaining_fly_time = max_fly_time
	is_flying = true
