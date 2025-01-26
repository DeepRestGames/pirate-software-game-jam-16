extends Node


# Add signals here to be triggered from any script
@warning_ignore("unused_signal")
signal fly_time_update(remaining_fly_time)
@warning_ignore("unused_signal")
signal fly_time_finished
@warning_ignore("unused_signal")
signal fly_time_reset

@warning_ignore("unused_signal")
signal throw_boomerang(starting_global_position)

@warning_ignore("unused_signal")
signal player_death

@warning_ignore("unused_signal")
signal difficulty_ramp_up

# Interactables
@warning_ignore("unused_signal")
signal start_opening_gateway

@warning_ignore("unused_signal")
signal next_level
