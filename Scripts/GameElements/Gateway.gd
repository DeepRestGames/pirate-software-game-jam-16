class_name Gateway
extends Area2D


@onready var sprite = $Sprite2D
@onready var gateway_particles = $Gateway_GPUParticles2D
@onready var glow_particles = $Glow_GPUParticles2D
@onready var time_left_label = $TimeLeftLabel

@export var opening_time: float = 10
@export var always_open = false
var time_left: float = 1
var open = false
var just_closed = false


func _ready() -> void:
	if always_open:
		open = true
		show_gateway_open_animation(true)
	else:
		EventBus.connect("start_opening_gateway", start_opening_gateway)


func _process(delta: float) -> void:
	gateway_particles.rotate(.005)
	
	if always_open:
		return
	
	if open:
		time_left -= delta
		var minutes = time_left / 60
		var seconds = fmod(time_left, 60)
		time_left_label.text = ("%02d" % minutes) + ":" + ("%02d" % seconds)
	
	if time_left <= 0 and not just_closed:
		just_closed = true
		EventBus.emit_signal("play_gate_close_sfx")
		EventBus.emit_signal("difficulty_down")
		open = false
		show_gateway_open_animation(false)
		time_left_label.hide()
	
	EventBus.emit_signal("gateway_time_left", time_left)


func show_gateway_open_animation(show_animation: bool):
	if show_animation:
		sprite.hide()
		gateway_particles.rotation = 0
		gateway_particles.show()
		glow_particles.show()
	else:
		sprite.show()
		gateway_particles.hide()
		glow_particles.hide()


func start_opening_gateway():
	time_left = opening_time
	EventBus.emit_signal("send_gateway_global_position", global_position)
	show_gateway_open_animation(true)
	open = true
	just_closed = false


func _on_body_entered(body: Node2D) -> void:
	if open and body is MainCharacter:
		EventBus.emit_signal("next_level")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if always_open:
		return
	
	if open:
		EventBus.emit_signal("gateway_on_screen")
		time_left_label.show()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if always_open:
		return
	
	if open:
		EventBus.emit_signal("gateway_off_screen")
		time_left_label.hide()
