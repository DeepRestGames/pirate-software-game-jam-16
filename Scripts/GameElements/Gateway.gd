class_name Gateway
extends Area2D


@onready var sprite = $Sprite2D

@export var off_color: Color
@export var on_color: Color

@export var opening_time: float = 10

var opened = false


func _ready() -> void:
	sprite.modulate = off_color
	
	EventBus.connect("start_opening_gateway", start_opening_gateway)


func start_opening_gateway():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", on_color, opening_time)
	await tween.finished
	opened = true


func _on_body_entered(body: Node2D) -> void:
	if opened and body is MainCharacter:
		EventBus.emit_signal("next_level")
