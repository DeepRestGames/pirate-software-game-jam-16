class_name MainCharacter
extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D
@onready var path_calculation_timer = $PathCalculationTimer as Timer

@export var flying_boomerang: Boomerang
@onready var meelee_boomerang = $Boomerang

const movement_speed: float = 500
const meelee_boomerang_offset = 70

var boomerang_on_ground: bool = false
var boomerang_in_hand: bool = true
var boomerang_just_thrown = false


func _ready() -> void:
	EventBus.connect("fly_time_finished", move_to_boomerang)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw_boomerang"):
		throw_boomerang()


func _physics_process(delta: float) -> void:
	# Get navigation agent path only if boomerang is on the ground
	if boomerang_on_ground:
		var direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = direction * movement_speed
	else:
		velocity = Vector2.ZERO
	
	# If boomerang is in hand, move boomerang around player
	if boomerang_in_hand:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		meelee_boomerang.position = direction * meelee_boomerang_offset
		meelee_boomerang.look_at(direction)
	
	if move_and_slide():
		if boomerang_just_thrown:
			boomerang_just_thrown = false
			return
			
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider() is Boomerang:
				print("Boomerang retrieved!")
				boomerang_reached()


func throw_boomerang():
	boomerang_in_hand = false
	meelee_boomerang.hide()
	meelee_boomerang.process_mode = Node.PROCESS_MODE_DISABLED
	boomerang_just_thrown = true
	
	EventBus.emit_signal("throw_boomerang", meelee_boomerang.global_position)


func boomerang_reached():
	boomerang_on_ground = false
	boomerang_in_hand = true
	EventBus.emit_signal("fly_time_reset")
	meelee_boomerang.show()
	meelee_boomerang.process_mode = Node.PROCESS_MODE_INHERIT
	path_calculation_timer.stop()


func move_to_boomerang() -> void:
	boomerang_on_ground = true
	make_path()
	path_calculation_timer.start()


func make_path() -> void:
	navigation_agent.target_position = flying_boomerang.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()
