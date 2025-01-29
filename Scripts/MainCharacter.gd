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

const MOVEMENT_SPEED: float = 300
const MEELEE_BOOMERANG_OFFSET = 100

var boomerang_on_ground: bool = false
var boomerang_in_hand: bool = true
var boomerang_just_thrown = false

@onready var camera = $Camera2D
const default_camera_zoom = 1
const minimum_camera_zoom = .75
var current_camera_zoom: float
const camera_zoom_modifier = .0002


func _ready() -> void:
	EventBus.connect("fly_time_finished", move_to_boomerang)
	
	boomerang_teleport_timer.wait_time = boomerang_teleport_cooldown
	flying_boomerang.global_position = global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw_boomerang"):
		if not boomerang_in_hand and not boomerang_on_ground:
			drop_boomerang()
		elif boomerang_in_hand:
			throw_boomerang()
	
	if event.is_action_pressed("teleport_boomerang"):
		teleport_boomerang()


func _process(delta: float) -> void:
	var vector_to_boomerang = to_local(flying_boomerang.global_position)
	camera.position = lerp(camera.position, vector_to_boomerang / 2, delta * 10)
	current_camera_zoom = maxf(minimum_camera_zoom, default_camera_zoom - (vector_to_boomerang.length() * camera_zoom_modifier))
	camera.zoom = lerp(camera.zoom, Vector2(current_camera_zoom, current_camera_zoom), delta * 2) 


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


func drop_boomerang():
	flying_boomerang.drop_boomerang()


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
