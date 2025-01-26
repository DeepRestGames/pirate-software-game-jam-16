extends TextureRect


@export_custom(PROPERTY_HINT_NONE, "suffix:px") var screen_margin = 30

var starting_position: Vector2

@onready var main_character = $"./../../.."

var gateway_position: Vector2
var arrow_visible = false


func _ready() -> void:
	starting_position = position
	EventBus.connect("send_gateway_global_position", set_gateway_position)
	EventBus.connect("gateway_on_screen", hide)
	EventBus.connect("gateway_off_screen", show_arrow)


func set_gateway_position(gateway_global_position: Vector2):
	gateway_position = gateway_global_position
	show()
	arrow_visible = true


func show_arrow():
	if arrow_visible:
		show()


func _process(delta: float) -> void:
	var gateway_direction = main_character.global_position.direction_to(gateway_position)
	
	position = starting_position + (gateway_direction * starting_position) - (gateway_direction * Vector2(screen_margin, screen_margin))
	rotation = gateway_direction.angle()
