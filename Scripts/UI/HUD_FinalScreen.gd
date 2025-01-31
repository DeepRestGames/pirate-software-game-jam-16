extends Control


@onready var main_character = $"./../../.."
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer as Timer


func _ready() -> void:
	EventBus.connect("final_boss_defeated", on_final_boss_defeated)


func on_final_boss_defeated():
	get_tree().paused = true
	
	timer.start(1.5)
	await timer.timeout
	
	EventBus.emit_signal("screen_shake", 50, .1)
	
	timer.start(5)
	await timer.timeout
	
	animation_player.play("final_cinematic")
