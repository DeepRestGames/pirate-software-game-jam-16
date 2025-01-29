extends Control


@onready var fly_time_progress_bar = $FlyTimeProgressBar as TextureProgressBar
@onready var fly_time_icon = $FlyTimeIcon as Sprite2D


func _ready() -> void:
	EventBus.connect("fly_time_update", update_fly_time)
	EventBus.connect("fly_time_reset", fly_time_reset)


func update_fly_time(remaining_fly_time):
	fly_time_progress_bar.value = remaining_fly_time / 100


func fly_time_reset():
	fly_time_progress_bar.value = 1
