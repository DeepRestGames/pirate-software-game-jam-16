class_name GameLevel
extends Node2D


@export var level_number: int
@export var level_name: String
@export var next_level_scene: PackedScene


func _ready() -> void:
	EventBus.emit_signal("level_started", self)
