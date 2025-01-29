extends Control


@onready var hammer_recall_cooldown_progress_bar = $HammerRecallCooldownProgressBar as TextureProgressBar
@onready var hammer_recall_cooldown_icon = $HammerRecallCooldownIcon as Sprite2D


func _ready() -> void:
	EventBus.connect("hammer_recall_cooldown_update", update_hammer_recall_cooldown)
	EventBus.connect("hammer_recall_cooldown_reset", hammer_recall_cooldown_reset)


func update_hammer_recall_cooldown(remaining_hammer_recall_cooldown):
	hammer_recall_cooldown_progress_bar.value = remaining_hammer_recall_cooldown / 100


func hammer_recall_cooldown_reset():
	hammer_recall_cooldown_progress_bar.value = 1
