class_name KaelAnimationState
extends Node

enum State {
	IDLE,
	WALK,
	RUN,
	JUMP,
	FALL
}

var current_state: State = State.IDLE

func update_state(
        grounded: bool,
        horizontal_speed: float,
        sprinting: bool,
        vertical_velocity: float
) -> void:
        var next_state := State.IDLE

        if not grounded:
                if vertical_velocity > 0.0:
                        next_state = State.JUMP
                else:
                        next_state = State.FALL
        elif horizontal_speed > 0.1:
                if sprinting:
                        next_state = State.RUN
                else:
                        next_state = State.WALK

        if next_state != current_state:
                current_state = next_state
                print("KAEL STATE: ", State.keys()[current_state])

func get_state_name() -> String:
        return State.keys()[current_state]
