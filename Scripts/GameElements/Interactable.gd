class_name Interactable
extends Area2D


@onready var sprite = $Sprite2D

@export var off_color: Color
@export var on_color: Color

var activated = false


func _ready() -> void:
	sprite.modulate = off_color


func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	
	if body is Boomerang:
		sprite.modulate = on_color
		activated = true
		
		EventBus.emit_signal("start_opening_gateway")
		EventBus.emit_signal("difficulty_ramp_up")
