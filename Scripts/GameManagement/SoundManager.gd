extends Node


var music_audio_bus = AudioServer.get_bus_index("Music")
var sfx_audio_bus = AudioServer.get_bus_index("SFX")

@onready var music_stream_player = $Music_StreamPlayer as AudioStreamPlayer
@onready var sfx_stream_player = $SFX_StreamPlayer as AudioStreamPlayer

var sfx_lightning = preload("res://Assets/SFX/Mjöllnir - elemental-magic-spell-impact-outgoing-228342.mp3")
var sfx_loud_thunder = preload("res://Assets/SFX/Mjöllnir - loud-thunder-192165.mp3")
var sfx_metal_clash = preload("res://Assets/SFX/518992__amaiguri__swordclash.wav")
var sfx_gate_open = preload("res://Assets/SFX/416321__pjborg__alienhum4.wav")
var sfx_gate_close = preload("res://Assets/SFX/169994__peepholecircus__power-down.mp3")
var sfx_hammer_throw = preload("res://Assets/SFX/movement-swipe-whoosh-1-186575.mp3")
var sfx_hammer_pickup = preload("res://Assets/SFX/item-equip-6904.mp3")
var sfx_enemy_spawn = preload("res://Assets/SFX/enemy spawn.mp3")

var music_slain_norse_intro = preload("res://Assets/SFX/Mjöllnir - hall of the slain norse - intro.mp3")
var music_slain_norse_loop = preload("res://Assets/SFX/Mjöllnir - hall of the slain norse - loop.mp3")

@export var pitch_scale_variation: float = 0.15
var min_pitch_scale
var max_pitch_scale

var gate_open_sfx_id: int


func _ready() -> void:	
	EventBus.connect("update_music_volume", update_music_volume)
	EventBus.connect("update_sfx_volume", update_sfx_volume)
	
	EventBus.connect("play_music", play_music)
	
	EventBus.connect("play_lightning_sfx", play_lightning_sfx)
	EventBus.connect("play_thunder_sfx", play_thunder_sfx)
	EventBus.connect("play_projectile_deflect_sfx", play_projectile_deflect_sfx)
	EventBus.connect("play_gate_open_sfx", play_gate_open_sfx)
	EventBus.connect("play_gate_close_sfx", play_gate_close_sfx)
	EventBus.connect("play_throw_sound", play_throw_sound)
	EventBus.connect("play_pickup_sound", play_pickup_sound)
	EventBus.connect("play_enemy_spawn_sound", play_enemy_spawn_sound)
	
	min_pitch_scale = 1 - pitch_scale_variation
	max_pitch_scale = 1 + pitch_scale_variation
	
	sfx_stream_player.play()


func update_music_volume(new_music_volume: float):
	AudioServer.set_bus_volume_db(music_audio_bus, new_music_volume)


func update_sfx_volume(new_sfx_volume: float):
	AudioServer.set_bus_volume_db(sfx_audio_bus, new_sfx_volume)


func play_music():
	music_stream_player.play()


func play_lightning_sfx(volume):
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(sfx_lightning, 0, volume, randf_range(min_pitch_scale, max_pitch_scale))


func play_thunder_sfx():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(sfx_loud_thunder, 0, 0, randf_range(min_pitch_scale, max_pitch_scale))


func play_projectile_deflect_sfx():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(sfx_metal_clash, 0, 0, randf_range(min_pitch_scale, max_pitch_scale))


func play_gate_open_sfx():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	gate_open_sfx_id = playback.play_stream(sfx_gate_open)


func play_gate_close_sfx():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.stop_stream(gate_open_sfx_id)
	playback.play_stream(sfx_gate_close)


func play_throw_sound():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(sfx_hammer_throw, 0, 0, randf_range(min_pitch_scale, max_pitch_scale))


func play_pickup_sound():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(sfx_hammer_pickup, 0, 0, randf_range(min_pitch_scale, max_pitch_scale))


func play_enemy_spawn_sound():
	var playback = sfx_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(sfx_enemy_spawn, 0, 0, randf_range(min_pitch_scale, max_pitch_scale))


func _on_music_stream_player_finished() -> void:
	music_stream_player.stream = music_slain_norse_loop
	music_stream_player.play()
