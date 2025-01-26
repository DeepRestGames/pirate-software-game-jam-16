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


# General events
@warning_ignore("unused_signal")
signal player_death

@warning_ignore("unused_signal")
signal difficulty_ramp_up


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
signal spawn_projectile_deflection_particles(global_position)
