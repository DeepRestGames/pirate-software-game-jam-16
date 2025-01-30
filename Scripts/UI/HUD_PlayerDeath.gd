extends Control


@onready var animation_player = $AnimationPlayer
@onready var random_hint_label = $DeathScreen/RandomHintLabel

@export var random_hints_list: Array[String]


func _ready() -> void:
	EventBus.connect("player_death", player_death)
	random_hint_label.text = random_hints_list.pick_random()


func player_death():
	animation_player.play("show_death_screen")
