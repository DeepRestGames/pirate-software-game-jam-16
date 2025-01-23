class_name MainCharacter
extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D
@onready var path_calculation_timer = $PathCalculationTimer as Timer
@onready var boomerang_teleport_timer = $BoomerangTeleportTimer as Timer
@onready var teleport_cooldown_progress_bar = $TeleportCooldown/TextureProgressBar

@export var flying_boomerang: Boomerang
@onready var meelee_boomerang = $Boomerang

@export var boomerang_teleport_cooldown: float = 5
var current_boomerang_teleport_cooldown: float = 0

const MOVEMENT_SPEED: float = 500
const MEELEE_BOOMERANG_OFFSET = 70

var boomerang_on_ground: bool = false
var boomerang_in_hand: bool = true
var boomerang_just_thrown = false


func _ready() -> void:
	EventBus.connect("fly_time_finished", move_to_boomerang)
	
	boomerang_teleport_timer.wait_time = boomerang_teleport_cooldown


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw_boomerang"):
		throw_boomerang()
	
	if event.is_action_pressed("teleport_boomerang"):
		teleport_boomerang()
	
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	# Get navigation agent path only if boomerang is on the ground
	if boomerang_on_ground:
		var direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = direction * MOVEMENT_SPEED
	else:
		velocity = Vector2.ZERO
	
	# If boomerang is in hand, move boomerang around player
	if boomerang_in_hand:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		meelee_boomerang.position = direction * MEELEE_BOOMERANG_OFFSET
		meelee_boomerang.look_at(direction)
	
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider() is Boomerang:
				boomerang_reached()
			
			if collision.get_collider().is_in_group("Enemies"):
				take_damage()
	
	if current_boomerang_teleport_cooldown > 0:
		current_boomerang_teleport_cooldown -= delta
		
		var remaining_teleport_cooldown = (current_boomerang_teleport_cooldown * 100) / boomerang_teleport_cooldown
		teleport_cooldown_progress_bar.value = remaining_teleport_cooldown
	else:
		teleport_cooldown_progress_bar.hide()
	

func take_damage():
	EventBus.emit_signal("player_death")
	hide()


func teleport_boomerang():
	if boomerang_in_hand:
		return
	
	if current_boomerang_teleport_cooldown <= 0:
		boomerang_reached()
		current_boomerang_teleport_cooldown = boomerang_teleport_cooldown
		teleport_cooldown_progress_bar.show()


func throw_boomerang():
	if not boomerang_in_hand:
		return
	
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
