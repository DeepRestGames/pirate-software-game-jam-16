extends Control


@onready var animation_player = $AnimationPlayer

var current_slide = 0


@onready var tizio = $ColorRectBackground/Tizio_TextureRect
@onready var hammer = $ColorRectBackground/Hammer_TextureRect
@onready var tizio_and_hammer = $ColorRectBackground/Together_TextureRect

@onready var text1 = $ColorRectBackground/Textbox1
@onready var text2 = $ColorRectBackground/Textbox2
@onready var text3 = $ColorRectBackground/Textbox3
@onready var text4 = $ColorRectBackground/Textbox4
@onready var text5 = $ColorRectBackground/Textbox5
@onready var text6 = $ColorRectBackground/Textbox6
@onready var text7 = $ColorRectBackground/Textbox7
@onready var text8 = $ColorRectBackground/Textbox8
@onready var text9 = $ColorRectBackground/Textbox9



func _ready() -> void:
	animation_player.play("loading_screen")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dialogic_default_action"):
		next_slide()


func next_slide():
	current_slide += 1
	
	match(current_slide):
		1:
			text1.show()
		2:
			text1.hide()
			text2.show()
		3:
			text2.hide()
			text3.show()
		4:
			text3.hide()
			hammer.show()
			text4.show()
			EventBus.emit_signal("play_thunder_sfx")
		5:
			text4.hide()
			hammer.hide()
			text5.show()
		6:
			text5.hide()
			hammer.show()
			text6.show()
		7:
			text6.hide()
			hammer.hide()
		8:
			text7.show()
		9:
			text7.hide()
			tizio_and_hammer.show()
		10:
			text8.show()
		11:
			text8.hide()
			text9.show()
		12:
			animation_player.play_backwards("loading_screen")
			await animation_player.animation_finished
			get_tree().change_scene_to_file("res://Scenes/Level Design/Final Levels/1. Tutorial 1 - Gate.tscn")
		
