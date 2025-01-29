class_name Interactable
extends Area2D


@onready var sprite = $Sprite2D
@onready var button_on_particles = $ButtonON_GPUParticles2D
@onready var button_off_particles = $ButtonOFF_GPUParticles2D2

@export var off_color: Color
@export var on_color: Color

var activated = false


func _ready() -> void:
	sprite.modulate = off_color
	EventBus.connect("difficulty_down", interactable_off)


func interactable_off():
	sprite.modulate = off_color
	button_off_particles.show()
	button_on_particles.hide()
	activated = false


func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	
	if body is Boomerang:
		sprite.modulate = on_color
		button_off_particles.hide()
		button_on_particles.show()
		activated = true
		
		EventBus.emit_signal("start_opening_gateway")
		EventBus.emit_signal("difficulty_ramp_up")
