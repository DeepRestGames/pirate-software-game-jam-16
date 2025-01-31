class_name GameLevel
extends Node2D


@export var level_number: int
@export var level_name: String
@export var next_level_scene: PackedScene

@export_category("Level events")
@export var signal_name_trigger: String
@export var triggered_dialogue_name: String


func _ready() -> void:
	EventBus.connect(signal_name_trigger, trigger_dialogue)
	EventBus.emit_signal("level_started", self)


func trigger_dialogue(_fake_parameter = null):
	Dialogic.start(triggered_dialogue_name).process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.timeline_ended.connect(func():get_tree().set('paused', false))
	get_tree().paused = true
