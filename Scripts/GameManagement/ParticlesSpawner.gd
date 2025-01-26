extends Node2D


@export var projectile_deflection_particles: PackedScene


func _ready() -> void:
	EventBus.connect("spawn_projectile_deflection_particles", spawn_projectile_deflection_particles)


func spawn_projectile_deflection_particles(particles_position: Vector2):
	var particles_instance = projectile_deflection_particles.instantiate() as GPUParticles2D
	add_child(particles_instance)
	particles_instance.global_position = particles_position
	
	particles_instance.restart()
	await particles_instance.finished
	particles_instance.queue_free()
