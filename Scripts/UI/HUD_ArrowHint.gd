extends Control


@export_custom(PROPERTY_HINT_NONE, "suffix:px") var screen_margin = 30

var starting_position: Vector2

@onready var main_character = $"./../../.."
@onready var arrow_texture = $ArrowHintTexture
@onready var time_left_label = $TimeLeftLabel

var gateway_position: Vector2
var arrow_visible = false


func _ready() -> void:
	starting_position = position
	EventBus.connect("send_gateway_global_position", set_gateway_position)
	EventBus.connect("gateway_time_left", update_time_left)
	EventBus.connect("gateway_on_screen", hide)
	EventBus.connect("gateway_off_screen", show_arrow)


func set_gateway_position(gateway_global_position: Vector2):
	gateway_position = gateway_global_position
	show()
	arrow_visible = true


func update_time_left(time_left: float):
	if time_left < 0:
		time_left_label.hide()
		arrow_texture.hide()
		return
	
	var minutes = time_left / 60
	var seconds = fmod(time_left, 60)
	time_left_label.text = ("%02d" % minutes) + ":" + ("%02d" % seconds)


func show_arrow():
	if arrow_visible:
		show()


func _process(_delta: float) -> void:
	var gateway_direction = main_character.global_position.direction_to(gateway_position)
	
	position = starting_position + (gateway_direction * starting_position) - (gateway_direction * Vector2(screen_margin, screen_margin))
	arrow_texture.rotation = gateway_direction.angle()
