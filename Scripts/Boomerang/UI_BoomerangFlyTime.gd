extends Control


@onready var fly_time_sprite = $FlyTimeContainer/FlyTimeSprite
@onready var fly_time_finished_cue = $FlyTimeContainer/FlyTimeFinishedCue
@onready var retrieve_weapon_label = $FlyTimeContainer/RetrievingWeaponLabel


func _ready() -> void:
	EventBus.connect("fly_time_update", update_fly_time)
	EventBus.connect("fly_time_finished", fly_time_finished)
	EventBus.connect("fly_time_reset", fly_time_reset)


func update_fly_time(remaining_fly_time):
	fly_time_sprite.scale.x = remaining_fly_time / 100


func fly_time_finished():
	fly_time_sprite.hide()
	fly_time_finished_cue.show()
	retrieve_weapon_label.show()


func fly_time_reset():
	fly_time_sprite.scale.x = 1
	fly_time_sprite.show()
	fly_time_finished_cue.hide()
	retrieve_weapon_label.hide()
