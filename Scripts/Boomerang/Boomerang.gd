extends Node2D

@onready var rigid_body = $RigidBody2D
@onready var sprite = $RigidBody2D/Sprite2D

@export_range(2.5, 10) var max_fly_time: float = 2.5
@export var speed = 300


func _process(delta: float) -> void:
	sprite.rotate(.05)


func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var direction =  mouse_position - rigid_body.global_position
	var motion_vector = direction.normalized() * speed
	
	#print("Mouse position: " + str(mouse_position))
	#print("Body position: " + str(position))
	#print("Direction: " + str(direction))
	
	rigid_body.apply_central_force(motion_vector)
