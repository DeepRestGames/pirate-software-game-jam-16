extends Node2D


var spark_particles = preload("res://Scenes/Particles/SparkParticles.tscn")
var blood_splatter_particles = preload("res://Scenes/Particles/BloodSplatterParticles.tscn")


func _ready() -> void:
	EventBus.connect("spawn_spark_particles", spawn_spark_particles)
	EventBus.connect("spawn_blood_particles", spawn_blood_particles)
	
	spawn_spark_particles(Vector2(100000, 100000))
	spawn_blood_particles(Vector2(100000, 100000))


func spawn_spark_particles(particles_position: Vector2):
	var particles_instance = spark_particles.instantiate() as GPUParticles2D
	get_tree().root.add_child.call_deferred(particles_instance)
	particles_instance.global_position = particles_position
	
	particles_instance.restart()
	await particles_instance.finished
	particles_instance.queue_free()


func spawn_blood_particles(particles_position: Vector2):
	var particles_instance = blood_splatter_particles.instantiate() as GPUParticles2D
	get_tree().root.add_child.call_deferred(particles_instance)
	particles_instance.global_position = particles_position
	
	particles_instance.restart()
	await particles_instance.finished
	particles_instance.queue_free()
