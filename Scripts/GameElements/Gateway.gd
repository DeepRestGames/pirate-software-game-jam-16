class_name Gateway
extends Area2D


@onready var sprite = $Sprite2D
@onready var time_left_label = $TimeLeftLabel

@export var off_color: Color
@export var on_color: Color

@export var opening_time: float = 10
var time_left: float
var is_opening = false
var opened = false


func _ready() -> void:
	sprite.modulate = off_color
	
	EventBus.connect("start_opening_gateway", start_opening_gateway)


func _process(delta: float) -> void:
	if is_opening:
		time_left -= delta
		var minutes = time_left / 60
		var seconds = fmod(time_left, 60)
		time_left_label.text = ("%02d" % minutes) + ":" + ("%02d" % seconds)
	
	if time_left <= 0:
		is_opening = false
		opened = true
		time_left_label.hide()
	
	EventBus.emit_signal("gateway_time_left", time_left)


func start_opening_gateway():
	EventBus.emit_signal("send_gateway_global_position", global_position)
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", on_color, opening_time)
	
	time_left = opening_time
	is_opening = true


func _on_body_entered(body: Node2D) -> void:
	if opened and body is MainCharacter:
		EventBus.emit_signal("next_level")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if(is_opening):
		EventBus.emit_signal("gateway_on_screen")
		time_left_label.show()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if(is_opening):
		EventBus.emit_signal("gateway_off_screen")
		time_left_label.hide()
