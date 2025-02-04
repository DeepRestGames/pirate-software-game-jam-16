extends Node


# Add signals here to be triggered from any script

# Boomerang actions
@warning_ignore("unused_signal")
signal fly_time_update(remaining_fly_time)

@warning_ignore("unused_signal")
signal fly_time_finished

@warning_ignore("unused_signal")
signal fly_time_reset

@warning_ignore("unused_signal")
signal throw_boomerang(starting_global_position)

@warning_ignore("unused_signal")
signal hammer_recall_cooldown_update(remaining_cooldown_time)

@warning_ignore("unused_signal")
signal hammer_recall_cooldown_reset


# General events
@warning_ignore("unused_signal")
signal player_death

@warning_ignore("unused_signal")
signal difficulty_ramp_up

@warning_ignore("unused_signal")
signal difficulty_down

@warning_ignore("unused_signal")
signal screen_shake(magnitude, duration)

@warning_ignore("unused_signal")
signal final_boss_defeated


# Interactables
@warning_ignore("unused_signal")
signal send_gateway_global_position(gateway_global_position)

@warning_ignore("unused_signal")
signal start_opening_gateway

@warning_ignore("unused_signal")
signal gateway_time_left(time_left)

@warning_ignore("unused_signal")
signal gateway_on_screen

@warning_ignore("unused_signal")
signal gateway_off_screen


# Screen management
@warning_ignore("unused_signal")
signal next_level

@warning_ignore("unused_signal")
signal level_started(game_level: GameLevel)


# Particles
@warning_ignore("unused_signal")
signal spawn_spark_particles(global_position)

@warning_ignore("unused_signal")
signal spawn_blood_particles(global_position)


# Audio
@warning_ignore("unused_signal")
signal play_music

@warning_ignore("unused_signal")
signal update_music_volume(music_volume)

@warning_ignore("unused_signal")
signal update_sfx_volume(sfx_volume)

@warning_ignore("unused_signal")
signal play_lightning_sfx(volume)

@warning_ignore("unused_signal")
signal play_thunder_sfx

@warning_ignore("unused_signal")
signal play_projectile_deflect_sfx

@warning_ignore("unused_signal")
signal play_gate_open_sfx

@warning_ignore("unused_signal")
signal play_gate_close_sfx

@warning_ignore("unused_signal")
signal play_throw_sound

@warning_ignore("unused_signal")
signal play_pickup_sound

@warning_ignore("unused_signal")
signal play_enemy_spawn_sound

@warning_ignore("unused_signal")
signal play_enemy_death_sound


# Dialogues
@warning_ignore("unused_signal")
signal play_timeline(timeline_name)
