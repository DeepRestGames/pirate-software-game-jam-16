class_name GameLevel
extends Node2D


@export var level_number: int
@export var level_name: String
@export var next_level_scene: PackedScene

@export_category("Level events")
@export var signal_name_trigger: String
@export var triggered_dialogue_name: String


#var dialogue1 = ResourceLoader.load("res://Assets/Dialogues/AlarmTimeline.dtl")
#var dialogue2 = ResourceLoader.load("res://Assets/Dialogues/AssassinsTimeline.dtl")
#var dialogue3 = ResourceLoader.load("res://Assets/Dialogues/BossTimeline.dtl")
#var dialogue4 = ResourceLoader.load("res://Assets/Dialogues/DialogueStyle.tres")
#var dialogue5 = ResourceLoader.load("res://Assets/Dialogues/HammerDropTimeline.dtl")
#var dialogue6 = ResourceLoader.load("res://Assets/Dialogues/OpenPortalTimeline.dtl")
#var dialogue7 = ResourceLoader.load("res://Assets/Dialogues/RangedEnemiesTimeline.dtl")
#var dialogue8 = ResourceLoader.load("res://Assets/Dialogues/RecallTimeline.dtl")
#var dialogue9 = ResourceLoader.load("res://Assets/Dialogues/ThorTimeline.dtl")
#var dialogue10 = ResourceLoader.load("res://Assets/Dialogues/ThrowHammerTimeline.dtl")
#var dialogue11 = ResourceLoader.load("res://Assets/Dialogues/WalkingEnemiesTimeline.dtl")


#func _ready() -> void:
	#EventBus.connect(signal_name_trigger, trigger_dialogue)
	#EventBus.emit_signal("level_started", self)
#
#
#func trigger_dialogue(_fake_parameter = null):
	#pass
	#
	#Dialogic.start(triggered_dialogue_name).process_mode = Node.PROCESS_MODE_ALWAYS
	#Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	#Dialogic.timeline_ended.connect(func():get_tree().set('paused', false))
	#get_tree().paused = true
