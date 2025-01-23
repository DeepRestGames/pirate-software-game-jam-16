extends Control


@onready var player_death_sceen = $DeathScreen


func _ready() -> void:
		EventBus.connect("player_death", player_death)


func player_death():
	player_death_sceen.show()
